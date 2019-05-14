
got count [{{ key "default/count" }}], expected <1> - direct key lookup
{{ $location := or (env "CLUSTER_LOCATION" ) "us-west-1" }}
{{ $app := or (env "APP" ) "myapp"}}
{{ $release := or (env "RELEASE" ) "release1"}}
{{ $env := or (env "ENVIRONMENT" ) "qa"}}

{{$location}}_{{$env}}={{plugin "hiera-ctp" "pgdb/url"  $location $env }}

{{$app}}_{{$location}}_{{$env }}={{plugin "hiera-ctp" "pgdb/url"  $app $location $env  }}

{{$release}}_{{$app}}_{{$location}}_{{$env }}={{plugin "hiera-ctp" "pgdb/url" $release $app $location $env  }}

Getting JSON value

{{with $d := plugin "hiera-ctp" "mysql" $release $app $location $env | parseJSON }}
url = {{$d.url}}
user = {{$d.user}}
{{end}}




