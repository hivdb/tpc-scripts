build:
	@docker build -t hivdb/tpc-all .

serve:
	@mkdir -p data/luceneindex
	@mkdir -p data/tpcas
	@mkdir -p data/postgres
	@docker rm -f tpc-instance 2>/dev/null || true
	@docker run \
		-p 0.0.0.0:18080:80 \
		--detach \
		-v $(shell pwd)/data/luceneindex:/data/luceneindex \
		-v $(shell pwd)/data/tpcas:/data/tpcas \
		-v $(shell pwd)/data/tpcas:/data/postgres \
		--name tpc-instance hivdb/tpc-all
	@echo 'View live logs with command `docker logs -f tpc-instance`.'
	@echo "Access the service: http://zhangfei:18080/"

shell:
	@docker rm -f tpc-shell 2>/dev/null || true
	@docker run --rm -it --name tpc-shell --entrypoint "/bin/bash" hivdb/tpc-all
