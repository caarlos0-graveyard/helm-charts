#!/bin/sh
set -e
#
# this is very hacky... at best.
#

for component in compact query sidecar store; do
	mkdir -p thanos/files
	curl -s "https://raw.githubusercontent.com/improbable-eng/thanos/master/examples/grafana/thanos-$component.json" |
		jq 'del(.__inputs, .__requires)' |
		gsed \
			-e 's/${DS_PROMETHEUS}/Prometheus/g' \
			-e 's/${VAR_LABELSELECTOR}/job/g' \
			-e 's/${VAR_LABELVALUE}/thanos-'"$component"'-http/g' > "./thanos/files/thanos-$component.json"
	cat > "./thanos/templates/grafana/thanos-$component.yaml" <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "thanos.fullname" . }}-grafana-${component}
  labels:
    app.kubernetes.io/name: {{ include "thanos.name" . }}
    helm.sh/chart: {{ include "thanos.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    app.kubernetes.io/component: ${component}
    grafana_dashboard: "1"
data:
  {{- (.Files.Glob "files/thanos-$component.json").AsConfig | nindent 2 }}

EOF
done
