
got [{{ key "default/count" }}], expected <1> - direct key lookup

{{ scratch.Set "foo" "bar" }}
{{ $location := "us-west"}}
{{ $app := "myapp"}}
{{ $env := "qa"}}
run plugin {{plugin "hiera-ctp" "a"  (scratch.Get "foo") ( print (scratch.Get "foo") $location) }}



{{plugin "hiera-ctp" "pgdb/url"  $location $env  $app }}




