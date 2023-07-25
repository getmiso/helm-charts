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
      app: {{ include "misolib.fullname" . }}
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
          {{- if eq (len .Values.services) 0}}
          ports:
            - name: {{ .Values.service.name }}
              containerPort: {{ .Values.service.targetPort }}
              protocol: TCP
          {{- else }}
          {{- range $service := .Values.services }}
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sleep", "90"]
          ports:
          {{- range $port := $service.ports }}
            - name: {{ $port.name }}
              containerPort: {{ $port.targetPort }}
              protocol: TCP
          {{- end }}
          {{- end }}
          {{- end }}
          env:
          {{- range $key, $val := .Values.env }}
            - name: {{ $key }}
              value: {{ $val | quote }}
          {{- end }}
          {{- if .Values.livenessProbe.enabled }}
          livenessProbe:
            httpGet:
              path: {{ .Values.livenessProbe.path }}
              port: {{ .Values.livenessProbe.port }}
          {{- end }}
          {{- if .Values.readinessProbe.enabled }}
          readinessProbe:
            httpGet:
              path: {{ .Values.readinessProbe.path }}
              port: {{ .Values.readinessProbe.port }}
          {{- end }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      restartPolicy: {{ .Values.restartPolicy }}
      terminationGracePeriodSeconds: {{ .Values.terminationGracePeriod }}
{{- end -}}