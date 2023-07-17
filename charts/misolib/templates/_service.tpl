{{- define "misolib.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "misolib.fullname" . }}
  labels:
    {{- include "misolib.labels" . | nindent 4 }}
  annotations:
    {{- with .Values.service.annotations }}
    {{ toYaml . | indent 4 }}
    {{- end }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
      protocol: TCP
      name: {{ .Values.service.name }}
  {{- if .Values.service.additionalPorts }}
  {{ toYaml .Values.service.additionalPorts | indent 4 }}
  {{- end }}
  selector:
    app: {{ include "misolib.fullname" . }}
{{- end }}