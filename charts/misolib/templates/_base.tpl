{{- define "misolib.base" -}}
{{- include "misolib.deployment" . }}
---
{{- if .Values.autoscaling.enabled }}
{{- include "misolib.hpa" . }}
{{- end}}
---
{{- include "misolib.service" . }}
---
{{- if .Values.serviceAccount.create }}
{{- include "misolib.serviceaccount" . }}
{{- end }}
{{- end -}}