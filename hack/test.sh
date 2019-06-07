#!/bin/sh
set -e

trap 'k3d delete -n thanos-test' EXIT

k3d create --name thanos-test --wait 0
export KUBECONFIG="$(k3d get-kubeconfig --name='thanos-test')"
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade --wait

helm install --namespace thanos --name thanos ./thanos \
	--wait \
	--timeout 600 \
	-f values.yaml \
	--set-file objectStore=thanos-storage-config.yaml

read -p "Press enter to continue"
