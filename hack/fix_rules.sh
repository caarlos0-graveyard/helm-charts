#!/bin/sh
for f in compact query sidecar store; do
	# shellcheck disable=2016
	gsed -i'' -e '13,$s/{{/{{`{{/g' -e '13,$s/}}/}}`}}/g' "./thanos/templates/$f-rules.yaml"
done
