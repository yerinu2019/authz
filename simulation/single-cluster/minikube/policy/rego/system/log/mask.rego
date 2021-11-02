package system.log

import input.parsed_body

mask[{"op": "upsert", "path": "/input/parsed_body", "value": "*** MASKED ***"}] {
    is_mutate
}

mask[{"op": "upsert", "path": "/input/attributes/request/http/body", "value": "*** MASKED ***"}] {
    is_mutate
}

is_mutate {
    lines := split(input.parsed_body["query"], "\n")
    some i
    line := trim_left(lines[i], " ")
    not startswith(line, "#")
    startswith(lower(line), "mutation")
}