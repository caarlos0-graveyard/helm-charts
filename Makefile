deps:
	cd thanos && helm dependency update

release:
	./hack/release.sh

test:
	./hack/test.sh

dash:
	./hack/download_dashboards.sh
