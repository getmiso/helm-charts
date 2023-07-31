{{- define "misolib.serviceaccount" -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "misolib.serviceAccountName" . }}
  labels:
    {{- include "misolib.labels" . | nindent 4 }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- with .Values.service.annotations }}
    {{ toYaml . | indent 4 }}
    {{- end }}
  {{- end }}
{{- end }}
