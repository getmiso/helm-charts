{{- define "misolib.externalsecret" -}}
{{- range $externalSecret := .Values.externalSecrets }}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ $externalSecret.name }}
  labels:
    {{- include "misolib.labels" $ | nindent 4 }}
spec:
  data:
    {{- range $data := $externalSecret.data }}
    - remoteRef:
        key: {{ $data.remoteRefKey }}
      secretKey: {{ $data.secretKey }}
    {{- end }}
  secretStoreRef:
    kind: ClusterSecretStore
    name: {{ $externalSecret.secretStoreRef }}
  target:
    name: {{ $externalSecret.target }}
---
{{- end }}
{{- end -}}