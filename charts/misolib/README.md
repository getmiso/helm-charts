# Miso Library Chart
This library chart is created as a helper to any other application charts that may use and benefit from predefined kubernetes objects and objects sets. As you know, this chart can not be used as stand-alone helm chart therefore can not be deployed alone.
As of now there are following predefined kubernetes object templates available for useage:
- deployment
- statefulset
- service
- serviceaccount
- hpa
- externalsecrets
- base

#### Configuration

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
    repository: https://raw.githubusercontent.com/getmiso/helm-charts/gh-pages
    import-values:
      - defaults
```

#### Default Values
The following tables lists the configurable parameters of the library and their default values.

| Parameter | Description | Default Value |
|:---------------------------------------------:|:--------------------------------------------------------------------------------:|:-------------:|
| `nameOverride` | Name of the deployment | `""` |
| `fullnameOverride` | Name to override all the resources in the template | `""` |
| `replicaCount` | Number of replicas deployment has | `1` |
| `image.repository` | AWS ECR Image repository of deployment | `hello-world` |
| `image.pullPolicy` | Pull policy of deployment docker image | `Always` |
| `image.tag` | Tag of the deployment docker image | `latest` |
| `imagePullSecrets` | Image pull secrets list to use when pulling docker image | `[]` |
| `podAnnotations` | Deployment pod annotations | `{}` |
| `podSecurityContext` | Security context of deployment pods | `{}` |
| `selectorLabels` | Pod selector labels used to link deployment pods with service | `NIL` |
| `service.targetPort` | Target port of the service | `80` |
| `service.additionalPorts` | Additional service ports list | `[]` |
| `resources.limits.cpu` | CPU limit of the deployment | `200m` |
| `resources.limit.memory` | Memory limit of the deployment | `200Mi` |
| `resources.request.cpu` | CPU request of the deployment | `100m` |
| `resources.request.memory` | Memory request of the deployment | `100Mi` |
| `livenessProbe.enabled` | Flag to enable liveness probe of deployment | `false` |
| `livenessProbe.path` | Http path to expose for liveness probe | `/` |
| `livenessProbe.port` | Http port to expose for liveness probe | `80` |
| `readinessProbe.enabled` | Flag to enable readiness probe of deployment | `false` |
| `readinessProbe.path` | Http path to expose for readiness probe | `/` |
| `readinessProbe.port` | Http port to expose for readiness probe | `80` |
| `nodeSelector` | Node selector configuration for deployment | `{}` |
| `tolerations` | Tolerations configuration list for deployment | `[]` |
| `affinity` | Affinity configuration for deployment | `{}` |
| `restartPolicy` | Deployment pod restart policy. | `Always` |
| `terminationGracePeriod` | Deployment pod termination grace period in seconds | `30` |
| `volumeMounts` | List of volume mounts to use in statefulsets | `[]` |
| `volumeClaimTemplates` | List of volume claim templates to use in statefulsets | `[]` |
| `services` | Additional services list. If this is not provided then following `service` value will take precedence. | `[]` |
| `services[INDEX].name` | Name of the service. | `Null` |
| `services[INDEX].ports` | List of ports for the first item(service) in the list | `[]` |
| `services[INDEX].ports[INDEX].name` | Name of the port | `Null` |
| `services[INDEX].ports[INDEX].port` | Port number | `Null` |
| `services[INDEX].ports[INDEX].targetPort` | Target port number of the service's port | `Null` |
| `service.annotations` | Annotations to add to service. | `{}` |
| `service.type` | Service resource type: NodePort, ClusterIp | `NodePort` |
| `service.port` | Port of the service | `80` |
| `service.portName` | Name of the port | `""` |
| `autoscaling.enabled` | Flag to enable HorizontalPodAutoscaling for deployment | `false` |
| `autoscaling.minReplicas` | Minimum number of replica count of HorizontalPodAutoscaling | `1` |
| `autoscaling.maxReplicas` | Maximum number of replica count of HorizontalPodAutoscaling | `10` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utlization threshhold, this indicates when to autoscale down or up | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utlization threshhold, this indicates when to autoscale down or up | `80` |
| `serviceAccount.create` | Service account to use in the deployment | `false` |
| `serviceAccount.annotations` | Service account annotations | `{}` |
| `serviceAccount.name` | Name of the service account | `""` |
| `env.ENV_VARIABLE_NAME` | Environament variable for deployment. You can define its name and value yourself | `ENV_VARIABLE_VALUE` |

#### Usage
You can use combination of any of the predefined templates from misolib library chart in your application charts. You just need to include them in your chart's yaml files. 
**Example:**
If you want to use `deployment`, and `service` templates then you can include them in your applicatin chart's yaml file as follows:
```yaml
{{ include "misolib.deployment" . }}
{{ include "misolib.service" . }}
```
