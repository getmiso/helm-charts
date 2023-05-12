### Miso Helm Charts repository.

This is the repository that we keep and host all the helm-charts for miso microservices hosted by kubernetes.

#### Branches

1. **main** - branch to keep and deploy charts.
2. **gh-pages** - branch to keep helm-generated chart files. *DO NOT CHANGE ANYTHING IN THIS BRANCH.*

#### Charts

All the charts are stored in `charts` folder. Currently we have following charts in our disposal:

- [deployment](https://github.com/getmiso/helm-charts/tree/main/charts/deployment)

#### CI/CD
There is a [relese-based deployment pipeline](https://github.com/getmiso/helm-charts/blob/main/.github/workflows/release.yml) that publishes each helm chart at once.