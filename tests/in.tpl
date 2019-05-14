
got [{{ key "default/count" }}], expected <1> - direct key lookup

{{ $location := "us-west-1"}}
{{ $app := "myapp"}}
{{ $release := "release1"}}
{{ $env := "qa"}}

{{$location}}_{{$env}}={{plugin "hiera-ctp" "psql/url"  $location $env }}

{{$app}}_{{$location}}_{{$env }}={{plugin "hiera-ctp" "pgdb/url"  $app $location $env  }}

{{$release}}_{{$app}}_{{$location}}_{{$env }}={{plugin "hiera-ctp" "pgdb/url" $release $app $location $env  }}

{{ $location := "us-east-2"}}

{{$release}}_{{$app}}_{{$location}}_{{$env }}={{plugin "hiera-ctp" "pgdb/url" $release $app $location $env  }}

{{ $release := "release2"}}

{{$release}}_{{$app}}_{{$location}}_{{$env }}={{plugin "hiera-ctp" "pgdb/url" $release $app $location $env  }}




