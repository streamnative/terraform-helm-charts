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

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the default image name for olm, catalog and package.
use quay.io/operator-framework/olm:v0.20.0 as default if related values are empty
*/}}
{{- define "olm.defaultImageName" -}}
{{- $registry := default "quay.io" .Values.image.registry }}
{{- $repository := default "operator-framework" .Values.image.repository }}
{{- $name := default "olm" .Values.image.name }}
{{- $tag := default "v0.20.0" .Values.image.tag  }}
{{- printf "%s/%s/%s:%s" $registry $repository $name $tag }}
{{- end }}

{{/*
Create the name of olm image
*/}}
{{- define "olm.image" -}}
{{- if .Values.olm.image.ref }}
{{- printf "%s" .Values.olm.image.ref }}
{{- else }}
{{- printf "%s" (include "olm.defaultImageName" . ) }}
{{- end }}
{{- end }}

{{/*
Create the name of catalog image
*/}}
{{- define "olm.catalogImage" -}}
{{- if .Values.catalog.image.ref }}
{{- printf "%s" .Values.catalog.image.ref }}
{{- else }}
{{- printf "%s" (include "olm.defaultImageName" . ) }}
{{- end }}
{{- end }}

{{/*
Create the name of package image
*/}}
{{- define "olm.packageImage" -}}
{{- if .Values.package.image.ref }}
{{- printf "%s" .Values.package.image.ref }}
{{- else }}
{{- printf "%s" (include "olm.defaultImageName" . ) }}
{{- end }}
{{- end }}

{{/*
Create the name of upstream operator catalog image
*/}}
{{- define "olm.upstreamOperatorCatalogImage" -}}
{{- if .Values.upstreamOperator.image.ref }}
{{- printf "%s" .Values.upstreamOperator.image.ref }}
{{- else }}
{{- $registry := default .Values.image.registry "quay.io" }}
{{- printf "%s/%s/%s:%s" $registry .Values.upstreamOperator.image.repository .Values.upstreamOperator.image.name .Values.upstreamOperator.image.tag }}
{{- end }}
{{- end }}