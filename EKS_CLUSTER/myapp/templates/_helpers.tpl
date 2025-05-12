{{- define "myapp.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "myapp.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}