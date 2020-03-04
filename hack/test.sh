#!/bin/sh
set -e

# trap 'k3d delete -n thanos-test' EXIT

k3d create --name thanos-test --wait 0 --image "docker.io/rancher/k3s:v0.9.1"
export KUBECONFIG="$(k3d get-kubeconfig --name='thanos-test')"
export PATH="/usr/local/opt/helm@2/bin:$PATH"

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade --wait

helm upgrade --install --namespace thanos minio \
	-f hack/minio.values.yaml \
    stable/minio

helm upgrade --install --namespace thanos thanos ./thanos \
	-f values.yaml \
	--set-file objectStore=hack/minio.thanos-storage-config.yaml \
	--set store.minTime=-4w \
	--set store.enableIndexHeader=true

# read -p "Press enter to continue"
