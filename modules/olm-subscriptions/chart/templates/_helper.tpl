{{/*
Get subscription config for bookkeeper
*/}}
{{- define "subscription.bookkeeperResources" -}}
{{- if .Values.bookkeeper.config.resources }}
  {{- toYaml .Values.bookkeeper.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}


{{/*
Get subscription config for flink
*/}}
{{- define "subscription.flinkResources" -}}
{{- if .Values.flink.config.resources }}
  {{- toYaml .Values.flink.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}

{{/*
Get subscription config for flink sql
*/}}
{{- define "subscription.flinkSQLResources" -}}
{{- if .Values.flinkSql.config.resources }}
  {{- toYaml .Values.flinkSql.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}

{{/*
Get subscription config for function mesh
*/}}
{{- define "subscription.functionMeshResources" -}}
{{- if .Values.functionMesh.config.resources }}
  {{- toYaml .Values.functionMesh.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}

{{/*
Get subscription config for prometheus
*/}}
{{- define "subscription.prometheusResources" -}}
{{- if .Values.prometheus.config.resources }}
  {{- toYaml .Values.prometheus.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}


{{/*
Get subscription config for pulsar
*/}}
{{- define "subscription.pulsarResources" -}}
{{- if .Values.pulsar.config.resources }}
  {{- toYaml .Values.pulsar.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}

{{/*
Get subscription config for sn-operator
*/}}
{{- define "subscription.snOperatorResources" -}}
{{- if .Values.sn_operator.config.resources }}
  {{- toYaml .Values.sn_operator.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}

{{/*
Get subscription config for zookeeper
*/}}
{{- define "subscription.zookeeperResources" -}}
{{- if .Values.zookeeper.config.resources }}
  {{- toYaml .Values.zookeeper.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}