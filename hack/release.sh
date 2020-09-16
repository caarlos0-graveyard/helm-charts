#!/bin/sh
set -e
helm lint charts/*
mkdir -p pkg

gsutil rsync gs://carlos-charts pkg
helm package charts/* --destination pkg

helm repo index pkg/ --url "https://carlos-charts.storage.googleapis.com"
gsutil rsync pkg gs://carlos-charts
gsutil setmeta -h "Cache-Control:private,max-age=0,no-transform" gs://carlos-charts/index.yaml

helm repo update
