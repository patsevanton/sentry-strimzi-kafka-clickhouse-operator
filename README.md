# sentry-strimzi-kafka-clickhouse-operator

# Kubernetes
cd postgresql
terraform init
terraform apply

# PostgreSQL
cd postgresql
terraform init
terraform apply

# Redis
cd redis
terraform init
terraform apply

# S3
cd s3
terraform init
terraform apply

```shell
helmwave up --build
```
# clickhouse operator
```shell
wget https://raw.githubusercontent.com/Altinity/clickhouse-operator/0.22.1/deploy/operator/clickhouse-operator-install-bundle.yaml
sed -i 's/image: /image: dockerhub.timeweb.cloud\//g' clickhouse-operator-install-bundle.yaml
```