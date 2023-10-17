{*
 Copyright 2023 StreamNative, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*}

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

{{/*
Get subscription config for elastic_cloud_eck
*/}}
{{- define "subscription.eckResources" -}}
{{- if .Values.elastic_cloud_eck.config.resources }}
  {{- toYaml .Values.elastic_cloud_eck.config.resources | nindent 6 }}
{{- else }}
  {{- toYaml .Values.subscriptionConfig.resources | nindent 6 }}
{{- end }}
{{- end }}