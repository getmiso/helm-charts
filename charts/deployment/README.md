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

#### How to deploy a particular microservice manually using this chart:
> This part assumes you have access to miso's kubernetes cluseters and you have set up helm cli tool into your local machine. If you have not, please follow [this](https://helm.sh/docs/intro/install/) guideline to install helm. 

Let's say you want to deploy microservice called `miso-local` and you want to serve it in port `8080`, miso-local also requires following environment variables:
```
PORT=value
KAKAO_API_KEY=value
JUSO_API_KEY=value
GRAPHQL_ENDPOINT=value
SNS_TOPIC_ARN=value
NAVER_CLIENT_ID=value
NAVER_CLIENT_SECRET=value
STAGE=value
```
Then you can generate `values.yaml` with following content:
```yml
fullnameOverride: miso-local
image:
    repository: $ECR_ADDRESS/miso/local
    tag: 'staging'

service:
    port: 8080
    targetPort: 8080
    name: miso-local
env:
    APP: value
    PORT: value
    KAKAO_API_KEY: value
    JUSO_API_KEY: value
    GRAPHQL_ENDPOINT: value
    SNS_TOPIC_ARN: value
    NAVER_CLIENT_ID: value
    NAVER_CLIENT_SECRET: value
    STAGE: value
```
Using above values you can apply it using helm:
```bash
helm install miso-local miso-charts/deployment --namespace front -f values.yaml
```

#### Automatic deployment
Keep in mind that there is a CI/CD pipeline that automatically creates `values.yaml` and applies it using github actions. 