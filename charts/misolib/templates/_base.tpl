{{- define "misolib.base" -}}
{{- include "misolib.deployment" . }}
---
{{- include "misolib.hpa" . }}
---
{{- include "misolib.service" . }}
---
{{- include "misolib.serviceaccount" . }}
{{- end -}}