### Miso helm chart for deployment

This chart is created to help deploy `deployment type` microservices into our eks clusters. This should serve as barebone skeleton to deploy applications. This skeleton can deploy following kubernetes objects in one installation:

- deployment
- service
- hpa
- serviceaccount

You should not use this chart without altering following:

```yml
fullnameOverride: microservice-name
image:
  repository: microservice-docker-image-url
  tag: "docker-image-tag-to-deploy"
```
