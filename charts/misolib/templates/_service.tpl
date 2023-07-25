{{- define "misolib.service" -}}
{{- if eq (len .Values.services) 0}}
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
      name: {{ .Values.service.portName }}
  {{- if .Values.service.additionalPorts }}
  {{ toYaml .Values.service.additionalPorts | indent 4 }}
  {{- end }}
  selector:
    app: {{ include "misolib.fullname" . }}
{{- else }}
{{- range $service := .Values.services }}
apiVersion: v1
kind: Service
metadata:
  name: {{ $service.name }}
  labels:
    {{- include "misolib.labels" $ | nindent 4 }}
  annotations:
    {{- range $annotation := $service.annotations }}
    {{ $annotation.name }}: {{ $annotation.value }}
    {{- end }}
spec:
  type: {{ $service.type | default "NodePort" | quote }}
  selector:
    app: {{ include "misolib.fullname" $ }}
  ports:
    {{- range $port := $service.ports }}
    - protocol: TCP
      port: {{ $port.port }}
      name: {{ $port.name }}
      targetPort: {{ $port.targetPort }}
    {{- end }}
---
{{- end }} # end of range
{{- end }} # end of if/else
{{- end }} # end of defenition