# sentry-strimzi-kafka-clickhouse-operator

# Kubernetes
```shell
cd kubernetes
terraform init
terraform apply
cd ..
```

# PostgreSQL
```shell
cd postgresql
terraform init
terraform apply
terraform output fqdn_database
terraform output users_data
cd ..
```

# Redis
```shell
cd redis
terraform init
terraform apply
cd ..
```

# S3
```shell
cd s3
terraform init
terraform apply
terraform output secret_key
cd ..
```

# Устанавливаем новое подключение к k8s

# namespace sentry
```shell
kubectl create namespace sentry
```

# Установка zookeeper, strimzi-kafka-operator
```shell
helmwave up --build
```

# clickhouse operator
```shell
wget https://raw.githubusercontent.com/Altinity/clickhouse-operator/0.22.1/deploy/operator/clickhouse-operator-install-bundle.yaml
sed -i 's/image: /image: dockerhub.timeweb.cloud\//g' clickhouse-operator-install-bundle.yaml
kubectl apply -f clickhouse-operator-install-bundle.yaml
```

# Пароль Clickhouse
Придумываем пароль и получаем от него sha256 хеш
```
printf 'sentry-password' | sha256sum
```
Полученный хеш вставляем в поле "sentry/password_sha256_hex"


# Clickhouse
Из примеров https://github.com/Altinity/clickhouse-operator/tree/master/docs/chi-examples сделать конфиг для clickhouse
Затем применить его
```shell
kubectl apply -f kind-ClickHouseInstallation.yaml
```

Импортируем дашборд https://grafana.com/grafana/dashboards/12163-altinity-clickhouse-operator-dashboard/

# kafka
# Из примеров https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/kafka берем Kafka и KafkaTopic
```
kubectl apply -f node-pool.yaml
kubectl apply -f kafka.yaml
kubectl apply -f kafka-topics.yaml
```