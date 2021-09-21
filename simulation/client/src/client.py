#!/usr/bin/python
#
# Copyright Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

from __future__ import print_function
from flask_bootstrap import Bootstrap
from flask import Flask, request, session, render_template, redirect, url_for
from flask import _request_ctx_stack as stack
from jaeger_client import Tracer, ConstSampler
from jaeger_client.reporter import NullReporter
from jaeger_client.codecs import B3Codec
from opentracing.ext import tags
from opentracing.propagation import Format
from opentracing_instrumentation.request_context import get_current_span, span_in_context
import simplejson as json
import requests
import sys
from json2html import *
import logging
import os
import asyncio

# These two lines enable debugging at httplib level (requests->urllib3->http.client)
# You will see the REQUEST, including HEADERS and DATA, and RESPONSE with HEADERS but without DATA.
# The only thing missing will be the response.body which is not logged.
try:
    import http.client as http_client
except ImportError:
    # Python 2
    import httplib as http_client
http_client.HTTPConnection.debuglevel = 1

app = Flask(__name__)
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)
requests_log = logging.getLogger("requests.packages.urllib3")
requests_log.setLevel(logging.DEBUG)
requests_log.propagate = True
app.logger.addHandler(logging.StreamHandler(sys.stdout))
app.logger.setLevel(logging.DEBUG)

# Set the secret key to some random bytes. Keep this really secret!
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'

Bootstrap(app)

servicesDomain = ".api-istio.svc.cluster.local" if (os.environ.get("SERVICES_DOMAIN") is None) else "." + os.environ.get("SERVICES_DOMAIN")
api1Hostname = "api1" if (os.environ.get("API1_HOSTNAME") is None) else os.environ.get("API1_HOSTNAME")
api2Hostname = "api2" if (os.environ.get("API2_HOSTNAME") is None) else os.environ.get("API2_HOSTNAME")

api1 = {
    "name": "http://{0}{1}".format(api1Hostname, servicesDomain),
    "endpoint": "api1",
    "children": []
}

api2 = {
    "name": "http://{0}{1}".format(api2Hostname, servicesDomain),
    "endpoint": "api2",
    "children": []
}


# A note on distributed tracing:
#
# Although Istio proxies are able to automatically send spans, they need some
# hints to tie together the entire trace. Applications need to propagate the
# appropriate HTTP headers so that when the proxies send span information, the
# spans can be correlated correctly into a single trace.
#
# To do this, an application needs to collect and propagate headers from the
# incoming request to any outgoing requests. The choice of headers to propagate
# is determined by the trace configuration used. See getForwardHeaders for
# the different header options.
#
# This example code uses OpenTracing (http://opentracing.io/) to propagate
# the 'b3' (zipkin) headers. Using OpenTracing for this is not a requirement.
# Using OpenTracing allows you to add application-specific tracing later on,
# but you can just manually forward the headers if you prefer.
#
# The OpenTracing example here is very basic. It only forwards headers. It is
# intended as a reference to help people get started, eg how to create spans,
# extract/inject context, etc.

# A very basic OpenTracing tracer (with null reporter)
tracer = Tracer(
    one_span_per_rpc=True,
    service_name='client',
    reporter=NullReporter(),
    sampler=ConstSampler(decision=True),
    extra_codecs={Format.HTTP_HEADERS: B3Codec()}
)


def trace():
    '''
    Function decorator that creates opentracing span from incoming b3 headers
    '''
    def decorator(f):
        def wrapper(*args, **kwargs):
            request = stack.top.request
            try:
                # Create a new span context, reading in values (traceid,
                # spanid, etc) from the incoming x-b3-*** headers.
                span_ctx = tracer.extract(
                    Format.HTTP_HEADERS,
                    dict(request.headers)
                )
                # Note: this tag means that the span will *not* be
                # a child span. It will use the incoming traceid and
                # spanid. We do this to propagate the headers verbatim.
                rpc_tag = {tags.SPAN_KIND: tags.SPAN_KIND_RPC_SERVER}
                span = tracer.start_span(
                    operation_name='op', child_of=span_ctx, tags=rpc_tag
                )
            except Exception as e:
                # We failed to create a context, possibly due to no
                # incoming x-b3-*** headers. Start a fresh span.
                # Note: This is a fallback only, and will create fresh headers,
                # not propagate headers.
                span = tracer.start_span('op')
            with span_in_context(span):
                r = f(*args, **kwargs)
                return r
        wrapper.__name__ = f.__name__
        return wrapper
    return decorator


def getForwardHeaders(request):
    headers = {}

    # x-b3-*** headers can be populated using the opentracing span
    #span = get_current_span()
    #print("SpanContext:" + str(span.context))
    #carrier = {}
    #tracer.inject(
    #    span_context=span.context,
    #    format=Format.HTTP_HEADERS,
    #    carrier=carrier)

    #headers.update(carrier)

    # We handle other (non x-b3-***) headers manually
    if 'user' in session:
        headers['end-user'] = session['user']

    # Keep this in sync with the headers in details and reviews.
    incoming_headers = [
        # All applications should propagate x-request-id. This header is
        # included in access log statements and is used for consistent trace
        # sampling and log sampling decisions in Istio.
        'x-request-id',

        # Lightstep tracing header. Propagate this if you use lightstep tracing
        # in Istio (see
        # https://istio.io/latest/docs/tasks/observability/distributed-tracing/lightstep/)
        # Note: this should probably be changed to use B3 or W3C TRACE_CONTEXT.
        # Lightstep recommends using B3 or TRACE_CONTEXT and most application
        # libraries from lightstep do not support x-ot-span-context.
        'x-ot-span-context',

        # Datadog tracing header. Propagate these headers if you use Datadog
        # tracing.
        'x-datadog-trace-id',
        'x-datadog-parent-id',
        'x-datadog-sampling-priority',

        # W3C Trace Context. Compatible with OpenCensusAgent and Stackdriver Istio
        # configurations.
        'traceparent',
        'tracestate',

        # Cloud trace context. Compatible with OpenCensusAgent and Stackdriver Istio
        # configurations.
        'x-cloud-trace-context',

        # Grpc binary trace context. Compatible with OpenCensusAgent nad
        # Stackdriver Istio configurations.
        'grpc-trace-bin',

        # b3 trace headers. Compatible with Zipkin, OpenCensusAgent, and
        # Stackdriver Istio configurations. Commented out since they are
        # propagated by the OpenTracing tracer above.
        'x-b3-traceid',
        'x-b3-spanid',
        'x-b3-parentspanid',
        'x-b3-sampled',
        'x-b3-flags',

        # Application-specific headers to forward.
        #'user-agent',
    ]
    # For Zipkin, always propagate b3 headers.
    # For Lightstep, always propagate the x-ot-span-context header.
    # For Datadog, propagate the corresponding datadog headers.
    # For OpenCensusAgent and Stackdriver configurations, you can choose any
    # set of compatible headers to propagate within your application. For
    # example, you can propagate b3 headers or W3C trace context headers with
    # the same result. This can also allow you to translate between context
    # propagation mechanisms between different applications.

    for ihdr in incoming_headers:
        val = request.headers.get(ihdr)
        if val is not None:
            headers[ihdr] = val

    return headers

# The UI:
@app.route('/')
def index():
    return 'call /api1 or /api2'

@app.route('/client1/<api_id>', endpoint="client1")
def callClient1(api_id):
    headers = getForwardHeaders(request)
    return callApi(api_id+servicesDomain, api_id, headers)

@app.route('/client2/<api_id>', endpoint="client2")
def callClient2(api_id):
    headers = getForwardHeaders(request)
    return callApi(api_id+servicesDomain, api_id, headers)

@app.route('/nonistio1/<api_id>', endpoint="nonistio1")
def callNonIstio1(api_id):
    headers = getForwardHeaders(request)
    return callApi(api_id+servicesDomain, api_id, headers)

@app.route('/nonistio2/<api_id>', endpoint="nonistio2")
def callNonIstio2(api_id):
    headers = getForwardHeaders(request)
    return callApi(api_id+servicesDomain, api_id, headers)

@app.route('/health')
def health():
    return 'Client service is healthy'

def callApi(host, endpoint, headers):
    try:
        url = "http://" + host + "/" + endpoint
        print("Calling " + url + " with headers: " + str(headers))
        res = requests.get(url, headers=headers, timeout=3.0)
    except BaseException as ex:
        print(ex)
        res = None
    if res is not None:
        ex = None
    if res and res.status_code == 200:
        print("Success!!!")
        return res.text, res.status_code, {'Content-Type': str(res.headers.get('content-type'))}
    else:
        print("Failed!!!")
        print(res)
        return res.text, res.status_code, {'Content-Type': str(res.headers.get('content-type'))}

class Writer(object):
    def __init__(self, filename):
        self.file = open(filename, 'w')

    def write(self, data):
        self.file.write(data)

    def flush(self):
        self.file.flush()


if __name__ == '__main__':
    if len(sys.argv) < 2:
        logging.error("usage: %s port" % (sys.argv[0]))
        sys.exit(-1)

    p = int(sys.argv[1])
    logging.info("start at port %s" % (p))
    # Python does not work on an IPv6 only host
    # https://bugs.python.org/issue10414
    app.run(host='0.0.0.0', port=p, debug=True, threaded=True)