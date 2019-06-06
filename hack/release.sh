#!/bin/sh
set -e
helm init --client-only
helm lint thanos
mkdir -p pkg
gsutil -p carlos-kube rsync gs://carlos-charts pkg
helm package thanos --destination pkg
helm repo index pkg/ --url "https://carlos-charts.storage.googleapis.com"
gsutil -p carlos-kube rsync pkg gs://carlos-charts
