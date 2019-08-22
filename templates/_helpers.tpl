{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "tor-privoxy-alpine-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expands image name.
*/}}
{{- define "tor-privoxy-alpine-chart.image" -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag -}}
{{- end -}}

{{/*
The standart k8s probe used for redinessProbe and livenessProbe
tor-privoxy-alpine-chart.probe is http get request
*/}}
{{- define "tor-privoxy-alpine-chart.probe" -}}
httpGet:
  path: /
  port: {{ .Values.service.internalPort }}
  initialDelay: 5
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "tor-privoxy-alpine-chart.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Environment for tor-privoxy-alpine-chart container
*/}}
{{- define "tor-privoxy-alpine-chart.env" -}}
- name: APP_ENV
  value: {{ .Values.app.env }}
{{- range $key, $value := .Values.app.vars }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}

{{/*
labels.standard prints the standard Helm labels.
The standard labels are frequently used in metadata.
*/}}
{{- define "tor-privoxy-alpine-chart.labels.standard" -}}
app: {{ template "tor-privoxy-alpine-chart.name" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
chart: {{ template "tor-privoxy-alpine-chart.chartref" . }}
{{- end -}}

{{/*
chartref prints a chart name and version.
It does minimal escaping for use in Kubernetes labels.
*/}}
{{- define "tor-privoxy-alpine-chart.chartref" -}}
  {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}

{{/*
Templates in tor-privoxy-alpine-chart.utils namespace are help functions.
*/}}

{{/*
tor-privoxy-alpine-chart.utils.tls functions makes host-tls from host name
usage: {{ "www.example.com" | tor-privoxy-alpine-chart.utils.tls }}
output: www-example-com-tls
*/}}
{{- define "tor-privoxy-alpine-chart.utils.tls" -}}
{{- $host := index . | replace "." "-" -}}
{{- printf "%s-tls" $host -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tor-privoxy-alpine-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "tor-privoxy-alpine-chart.labels" -}}
app.kubernetes.io/name: {{ include "tor-privoxy-alpine-chart.name" . }}
helm.sh/chart: {{ include "tor-privoxy-alpine-chart.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
