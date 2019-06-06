#!/bin/sh
set -e
helm init --client-only
helm lint thanos
mkdir -p pkg
gsutil rsync gs://carlos-charts pkg
helm package thanos --destination pkg
helm repo index pkg/ --url "https://carlos-charts.storage.googleapis.com"
gsutil rsync pkg gs://carlos-charts
