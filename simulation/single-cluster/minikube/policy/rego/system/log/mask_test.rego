package system.log

test_is_mutate {
  is_mutate with input as {
    "parsed_body": {
      "query": "# some comment lines\nmutation createIndexes {\n  user1: createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"favorite_books\",\n    indexName:\"fav_books_idx\",\n    indexKind: VALUES\n  )\n  user2:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"top_three_tv_shows\",\n    indexName:\"tv_idx\",\n    indexKind: VALUES\n  )\n  user3:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evalv_idx\",\n    indexKind: VALUES\n  )\n   user4:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evalk_idx\",\n    indexKind: KEYS\n  )\n   user5:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evale_idx\",\n    indexKind: ENTRIES\n  )\n    users6: createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"current_country\",\n    indexName:\"country_idx\"\n  )\n}",
      "variables": {}
    }
  }
}

test_is_not_mutate {
  not is_mutate with input as {
    "parsed_body": {
      "query":"query{showCollection {items { title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}"}
  }
}

test_mask_parsed_body {
    mask[{"op": "upsert", "path": "/input/parsed_body", "value": "MASKED"}] with input as {
    "parsed_body": {
      "query": "# some comment lines\nmutation createIndexes {\n  user1: createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"favorite_books\",\n    indexName:\"fav_books_idx\",\n    indexKind: VALUES\n  )\n  user2:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"top_three_tv_shows\",\n    indexName:\"tv_idx\",\n    indexKind: VALUES\n  )\n  user3:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evalv_idx\",\n    indexKind: VALUES\n  )\n   user4:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evalk_idx\",\n    indexKind: KEYS\n  )\n   user5:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evale_idx\",\n    indexKind: ENTRIES\n  )\n    users6: createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"current_country\",\n    indexName:\"country_idx\"\n  )\n}",
      "variables": {}
    }
  }
}

test_mask_http_body {
    mask[{"op": "upsert", "path": "/input/attributes/request/http/body", "value": "MASKED"}] with input as {
        "parsed_body": {
        "query": "# some comment lines\nmutation createIndexes {\n  user1: createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"favorite_books\",\n    indexName:\"fav_books_idx\",\n    indexKind: VALUES\n  )\n  user2:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"top_three_tv_shows\",\n    indexName:\"tv_idx\",\n    indexKind: VALUES\n  )\n  user3:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evalv_idx\",\n    indexKind: VALUES\n  )\n   user4:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evalk_idx\",\n    indexKind: KEYS\n  )\n   user5:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evale_idx\",\n    indexKind: ENTRIES\n  )\n    users6: createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"current_country\",\n    indexName:\"country_idx\"\n  )\n}",
        "variables": {}
        }
    }
}

test_no_mask_input {
    not mask[{"op": "upsert", "path": "/input", "value": "MASKED"}] with input as {
        "parsed_body": {
        "query": "# some comment lines\nmutation createIndexes {\n  user1: createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"favorite_books\",\n    indexName:\"fav_books_idx\",\n    indexKind: VALUES\n  )\n  user2:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"top_three_tv_shows\",\n    indexName:\"tv_idx\",\n    indexKind: VALUES\n  )\n  user3:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evalv_idx\",\n    indexKind: VALUES\n  )\n   user4:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evalk_idx\",\n    indexKind: KEYS\n  )\n   user5:createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"evaluations\",\n    indexName:\"evale_idx\",\n    indexKind: ENTRIES\n  )\n    users6: createIndex(\n    keyspaceName:\"\",\n    tableName:\"\",\n    columnName:\"current_country\",\n    indexName:\"country_idx\"\n  )\n}",
        "variables": {}
        }
    }
}

test_no_mask_parsed_body {
    not mask[{"op": "upsert", "path": "/input/parsed_body", "value": "MASKED"}] with input as {
        "parsed_body": {
        "query":"query{showCollection {items { title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}"}
    }
}

test_no_mask_http_body {
    not mask[{"op": "upsert", "path": "/input/attributes/request/http/body", "value": "MASKED"}] with input as {
        "parsed_body": {
        "query":"query{showCollection {items { title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}"}
    }
}