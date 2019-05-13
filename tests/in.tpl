
got [{{ key "default/count" }}], expected <1> - direct key lookup

{{ $location := "us-west-1"}}
{{ $app := "myapp"}}
{{ $env := "qa"}}

{{$location}}_{{$env}}={{plugin "hiera-ctp" "psql/url"  $location $env }}

{{$app}}_{{$location}}_{{$env }}={{plugin "hiera-ctp" "pgdb/url"  $app $location $env  }}




