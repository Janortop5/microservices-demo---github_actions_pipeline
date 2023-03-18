# altschool-cloud-engineering-3rd-semester-exam

### prerequisites for project
- aws account
- iam user with administrative access
- domain
- dockerhub account
- gitlab account

### prerequisites for pipeline
- remote backend for terraform state — a sample file to create s3 backend available in ./terraform/remote
- namecheap token
- create the following variables in gitlab:
```
AWS_CONFIG          [variable.type: file]
AWS_CREDENTIALS     [variable.type: file]
ENV_FILE            [variable.type: file]
MYSQL_DATABASE      [variable.type: variable]
MYSQL_ROOT_PASSWORD [variable.type: variable]
NAMEDOTCOMTOKEN     [variable.type: variable]
REGISTRY_PASS       [variable.type: variable]
REGISTRY_USER       [variable.type: variable]
```
- in "./terraform/variables" put namecheap token in var.namedotcom_token — setup of hashicorp vault in pipeline a little complex

## Breakdown
#### stage: test
- tests laravel app files before build, app uses nginx proxy, with nginx set to expose /metrics endpoint
```
cd portfolio_image/
docker build -t janortop5/portfolio .
```
#### stage: build
- builds laravel image and pushes to dockerhub account
```
docker login
```
#### stage: deploy
- deploys cluster with terraform, and deploys laravel app and microservices-demo
```
docker push janortop5/portfolio
```
#### How pipeline works
- **stage 'test':** creates laravel app along with mysql database as service in Gitlab runner using an ubuntu image, seeds the database and runs "php artisan test"

- **stage 'build':** build docker image of laravel app from file in ./laravel-app

- **stage 'deploy':** 
```
- setup Gitlab runner with the following Binary:
  • terraform
  • aws cli 
  • aws-iam-authenticator
  • helm
  • deploys terraform configuration and kubernetes manifests
```
#### ./terraform
- creates eks cluster and eks node group in private subnets with only 443 ingress rule
- sets remote backend as s3 bucket
- creates hosted zone
- creates nginx-ingress-controller and calls it's external address to attaches to a wildcard hosted zone record
- adds hosted zone nameservers to namedotcom domain using terraform namedotcom provider
#### ./deploy-laravel
- deployment of laravel app alongside an nginx exporter container for prometheus
- contains values for mysql exporter for prometheus
- service monitor for nginx exporter
- mysql secret
- laravel app ingress
- promethus-grafana ingress
- values for mysql exporter installation with helm
#### ./microservices-demo
- microservices complete deployment file
- custom made service monitors for all microservices
- front-end-ingress
- loki-ingress
#### ./lets-encrypt
- files for my let's-encrypt attempt
#### ./laravel
- laravel app files
#### ./images
- images of pipeline results and additional information
#### ./before_deploy.sh
- bash script to setup gitlab runner for deployment
- installs terraform
- installs aws-cli
- installs aws-iam-authenticator
- sets up runner to connect to cluster
#### ./deploy.sh
- deploys terraform configuration
- deploys laravel app with full monitoring
- deploys sock-shop app with full monitoring
- deploys service monitors
- deploys loki-grafana for logging
- deploys front-end-ingress
- deploys laravel-ingress
- deploys prometheus-grafana-ingress
- deploys loki-grafana-ingress
#### ./helm-commands.txt
- list of some helm commands used in pipeline
#### laravel and it's endpoint, screenshots
#### microservices-demo app screenshots
#### prometheus monitoring and metrics
#### loki logging
```
kubectl create -f portfolio.yml
```

### Screenshot of Deployed Website

![portfolilio website](./website-screenshots/screenshot-1.png)

![portfolio website](./website-screenshots/screenshot-2.png)
