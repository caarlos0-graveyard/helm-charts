#!/bin/sh
set -e
helm init --client-only
helm lint thanos
mkdir -p pkg

oldProj="$(gcloud config get-value project)"
trap 'gcloud config set project $oldProj' EXIT
gcloud config set project carlos-kube

oldAccount="$(gcloud config get-value account)"
trap 'gcloud config set account $oldAccount' EXIT
gcloud config set account carlos@carlosbecker.com

gsutil rsync gs://carlos-charts pkg
helm package thanos --destination pkg
helm repo index pkg/ --url "https://carlos-charts.storage.googleapis.com"
gsutil rsync pkg gs://carlos-charts
