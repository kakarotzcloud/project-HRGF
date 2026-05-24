{{- define "springboot-demo.name" -}}
springboot-demo
{{- end }}

{{- define "springboot-demo.fullname" -}}
{{ include "springboot-demo.name" . }}
{{- end }}

{{- define "springboot-demo.serviceAccountName" -}}
{{- if .Values.serviceAccount.name }}
{{ .Values.serviceAccount.name }}
{{- else }}
springboot-demo-sa
{{- end }}
{{- end }}