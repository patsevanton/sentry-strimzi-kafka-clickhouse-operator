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

OPERATOR_NAMESPACE="${OPERATOR_NAMESPACE:-clickhouse-operator}"
METRICS_EXPORTER_NAMESPACE="${OPERATOR_NAMESPACE}"
OPERATOR_IMAGE="${OPERATOR_IMAGE:-dockerhub.timeweb.cloud/altinity/clickhouse-operator:0.22.1}"
METRICS_EXPORTER_IMAGE="${METRICS_EXPORTER_IMAGE:-dockerhub.timeweb.cloud/metrics-exporter:latest}"

kubectl create namespace "${OPERATOR_NAMESPACE}"
kubectl apply --namespace="${OPERATOR_NAMESPACE}" -f <( \
    curl -s https://raw.githubusercontent.com/Altinity/clickhouse-operator/0.22.1/deploy/operator/clickhouse-operator-install-template.yaml | \
        OPERATOR_IMAGE="${OPERATOR_IMAGE}" \
        OPERATOR_NAMESPACE="${OPERATOR_NAMESPACE}" \
        METRICS_EXPORTER_IMAGE="${METRICS_EXPORTER_IMAGE}" \
        METRICS_EXPORTER_NAMESPACE="${METRICS_EXPORTER_NAMESPACE}" \
        envsubst \
)

kubectl apply -f https://raw.githubusercontent.com/Altinity/clickhouse-operator/0.22.1/deploy/operator/clickhouse-operator-install-bundle.yaml
```