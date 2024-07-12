# sentry-strimzi-kafka-clickhouse-operator

# Регистриуем домен на reg.ru
# Исправляем домен apatsev.org.ru на ваш домен везде в коде
# Версии приложений меняем осторожно, иначе могут быть баги, например https://github.com/ClickHouse/ClickHouse/issues/53749

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
terraform output owners_data
cd ..
```

# Redis
```shell
cd redis
terraform init
terraform apply
terraform output fqdn_redis
terraform output password
cd ..
```

# S3
```shell
cd s3
terraform init
terraform apply
terraform output access_key
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
wget -N https://raw.githubusercontent.com/Altinity/clickhouse-operator/0.23.6/deploy/operator/clickhouse-operator-install-bundle.yaml
kubectl apply -f clickhouse-operator-install-bundle.yaml
```

# kafka
# Из примеров https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/kafka берем Kafka и KafkaTopic
```
kubectl apply -f kafka-node-pool.yaml
kubectl apply -f kafka.yaml
kubectl apply -f kafka-topics.yaml
```
Ждем когда pod перейдут в состояние Running

# Clickhouse
Придумываем пароль и получаем от него sha256 хеш
```
printf 'sentry-password' | sha256sum
```
Полученный хеш вставляем в поле "sentry/password_sha256_hex"

Из примеров https://github.com/Altinity/clickhouse-operator/tree/master/docs/chi-examples сделать конфиг для clickhouse
Затем применить его
```shell
kubectl apply -f kind-ClickHouseInstallation.yaml
```
Ждем когда появятся 3 пода chi-sentry-clickhouse-sharded-x-0-0
Ждем когда все pod перейдут в состояние Running

# Установка sentry
Расскоментируем sentry в helmwave.yml
```shell
helmwave up --build
```

Ждем Clickhouse миграции в pod snuba-migrate
Ждем завершения PostgreSQL миграции в pod db-init-job
Чтобы увидеть когда закончатся миграции, можно использовать stern для просмотра логов в namespace sentry
```
stern -n sentry .
```

Входим в sentry по кредам, которые вы указали в этом коде
```
user:
  password: "пароль"
  create: true
  email: логин-в-виде-email
```
