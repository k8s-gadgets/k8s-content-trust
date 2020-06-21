{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the semantic API version to use
*/}}
{{- define "semanticAPIVersion" -}}
{{- printf "v%.1s" .Chart.AppVersion -}}
{{- end -}}



{{/*
following the variable "metadata" is introduced to replace variables naed like the chart
this makes it easier to understand and reuse
*/}}

{{/*
Create metadata.name variable
Tuncate at 63 chars because some Kubernetes name fileds are limited to this (by the DNS naminf spec).
*/}}
{{- define "metadata.name" -}}
{{- $name := default .appName -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create chart.name as version used by the chart label
*/}}
{{- define "metadata.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}



{{/*
Common labels
*/}}
{{- define "metadata.labels" -}}
helm.sh/chart: {{ include "metadata.chart" . }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/istance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "metadata.selectorLabels" -}}
{{ $parts := split "-" .appName }}

{{- if eq $parts._2 "sts" }}
app.kubernetes.io/name: {{ printf "%s-%s-sts" $parts._0 $parts._1 }}
{{- else if eq $parts._1 "db" }}
app.kubernetes.io/name: {{ printf "%s-%s-sts" $parts._0 $parts._1 }}
{{- else if eq $parts._2 "svc" }}
app.kubernetes.io/name: {{ printf "%s-%s-deploy" $parts._0 $parts._1 }}
{{- else }}
app.kubernetes.io/name: {{ include "metadata.name" . }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}



{{- define "metadata.imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.imageCredentials.registry (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.password | b64enc) | b64enc }}
{{- end }}
