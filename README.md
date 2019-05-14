Consul Template Plugin for hierarchical  key lookup.
---

Inspired by  https://puppet.com/docs/puppet/5.4/hiera_intro.html



Testing
---

start local Consul and push test data

	cd helpers
	./run-local-consul.sh &
	./set-sample-data.sh
	

retrieve data 

	cargo run pgdb/url qa us-west-1
