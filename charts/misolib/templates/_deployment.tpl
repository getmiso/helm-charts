{{- define "misolib.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "misolib.fullname" . }}
  labels:
    {{- include "misolib.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "misolib.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
      {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "misolib.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{if .Values.serviceAccount.create}}
      serviceAccount: {{ include "misolib.serviceAccountName" . }}
      serviceAccountName: {{ include "misolib.serviceAccountName" . }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ include "misolib.fullname" . }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sleep", "90"]
          {{- if eq (len .Values.services) 0}}
          ports:
            - name: {{ .Values.service.portName }}
              containerPort: {{ .Values.service.targetPort }}
              protocol: TCP
          {{- else }}
          ports:
          {{- $uniquePortNames := dict}}
          {{- range $service := .Values.services }}
          {{- range $port := $service.ports}}
          {{- if not (hasKey $uniquePortNames $port.name)}}
          {{- $_ := set $uniquePortNames $port.name $port.name}}
            - name: {{ $port.name }}
              containerPort: {{ $port.targetPort }}
              protocol: TCP
          {{- end }}
          {{- end }}
          {{- end }}
          {{- end }}
          env:
          {{- range $key, $val := .Values.env }}
            - name: {{ $key }}
              value: {{ $val | quote }}
          {{- end }}
          {{- with .Values.startupProbe }}
          startupProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.readinessProbe }}
          readinessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.livenessProbe }}
          livenessProbe:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: app
                    operator: In
                    values:
                      - {{ include "misolib.fullname" . }}
              topologyKey: "kubernetes.io/hostname"       
      
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      restartPolicy: {{ .Values.restartPolicy }}
      terminationGracePeriodSeconds: {{ .Values.terminationGracePeriod }}
{{- end -}}
