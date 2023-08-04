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
            {{- if and .Values.resources.production (eq .Values.stage "production") }}
            {{- toYaml .Values.resources.production | nindent 12 }}
            {{- else if and .Values.resources.staging (eq .Values.stage "staging") }}
            {{- toYaml .Values.resources.staging | nindent 12 }}
            {{- else }}
            limits:
              cpu: 300m
              memory: 500Mi
            requests:
              cpu: 200m
              memory: 350Mi
            {{- end}}
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