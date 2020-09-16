deps:
	cd charts/thanos && helm dependency update

release:
	./hack/release.sh

test:
	./charts/thanos/hack/test.sh

dash:
	./charts/thanos/hack/download_dashboards.sh
