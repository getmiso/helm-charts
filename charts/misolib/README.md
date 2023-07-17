# Miso Library Chart
Used as library for deployment.

To use this library chart:

1. Add `.helm` directory under your project root.
2. Set dependency in your helm chart file `.helm/Chart.yaml` like following:
```yaml
apiVersion: v2
name: miso-app
type: application
version: 1.2307.1
appVersion: "1.2307.1"
dependencies:
  - name: misolib
    version: 0.2.0
    repository: 
```
3. Use **misolib**'s base settings `.helm/templates/app.yaml` for your deployment like following:
```yaml
{{- include "misolib.base" . -}}
```
