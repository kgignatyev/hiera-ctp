#!/usr/bin/env bash

consul kv put default/count 1
consul kv put default/pgdb/url "postgresql://localhost/db"
consul kv put us-west-1/pgdb/url "postgresql://us-west-1/db"
consul kv put us-east-2/pgdb/url "postgresql://east/db"
consul kv put us-east-2/myapp/pgdb/url "postgresql://east-myapp/db"
consul kv put myapp/pgdb/url "postgresql://localhost/mydb"
consul kv put default/myapp/release1/pgdb/url "postgresql://localhost/mydb-r1"