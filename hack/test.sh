#!/bin/sh
set -e

# trap 'k3d delete -n thanos-test' EXIT
export KUBECONFIG=/tmp/thanos-test.config
k3d cluster create thanos-test || k3d cluster start thanos-test

helm upgrade --install --namespace thanos minio \
	--create-namespace \
	-f hack/minio.values.yaml \
	stable/minio

helm upgrade --install --namespace thanos thanos ./thanos \
	--create-namespace \
	-f values.yaml \
	--set-file objectStore=hack/minio.thanos-storage-config.yaml \
	--set store.minTime=-4w

# read -p "Press enter to continue"
