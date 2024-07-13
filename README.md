**Узнайте, как установить sentry в kubernetes, отловить exception на мобильных устройствах и в браузере. Часть 1**

В статье рассматривается Sentry — инструмент для сбора exception, который помогает разработчикам быстро обнаруживать и устранять проблемы, сокращая время выхода новых релизов и повышая удовлетворенность пользователей.

Sentry обладает следующими преимуществами:

 - Мониторинг exception на мобильных устройствах и в браузере

 - Открытый исходный код: Разработчики могут бесплатно использовать, модифицировать и расширять [Sentry](https://github.com/getsentry/sentry), благодаря активному сообществу.

 - Широкая поддержка языков и фреймворков: Поддерживает множество языков и фреймворков, делая его универсальным инструментом.

 - Детальная информация об exception: Предоставляет подробную информацию для быстрой идентификации и исправления проблем.

 - Аналитика и отчеты: Позволяет анализировать статистику exception и создавать детальные отчеты.

 - Самостоятельное развертывание: Возможность развертывания на собственных серверах для контроля над данными.

 - Обширная документация и поддержка сообщества: Помогает быстро начать работу и решать проблемы.

В этом посте будет рассмотрена минимальная установка Sentry в Kubernetes c clickhouse-operator и kafka-operator, так как установка sentry в kubernetes имеет много подводных камней. Используется clickhouse operator, так как sentry не работает с более новыми версиями clickhouse, которые предлагает Яндекс облако.

Более расширенная установка будет в следующем посте.

Регистриуем домен на reg.ru. Исправляем домен apatsev.org.ru на ваш домен везде в коде. Версии приложений меняем осторожно, иначе могут быть баги, например https://github.com/ClickHouse/ClickHouse/issues/53749.

Создаем Kubernetes.
```shell
cd kubernetes
terraform init
terraform apply
cd ..
```

Создаем PostgreSQL.
```shell
cd postgresql
terraform init
terraform apply
terraform output fqdn_database
terraform output owners_data
cd ..
```

Создаем Redis.
```shell
cd redis
terraform init
terraform apply
terraform output fqdn_redis
terraform output password
cd ..
```

Создаем S3.
```shell
cd s3
terraform init
terraform apply
terraform output access_key
terraform output secret_key
cd ..
```

Устанавливаем новое подключение к k8s.
```shell
yc managed-kubernetes cluster get-credentials --id xxxx --external
```

Создаем namespace sentry.
```shell
kubectl create namespace sentry
```

Установливаем zookeeper, altinity-clickhouse-operator, strimzi-kafka-operator.
```shell
helmwave up --build
```
Ждем когда pod перейдут в состояние Running.

Создаем kafka из примеров https://github.com/strimzi/strimzi-kafka-operator/tree/main/examples/kafka берем Kafka и KafkaTopic
```
kubectl apply -f kafka-node-pool.yaml
kubectl apply -f kafka.yaml
kubectl apply -f kafka-topics.yaml
```

Создаем Clickhouse. 
Придумываем пароль и получаем от него sha256 хеш.
```
printf 'sentry-clickhouse-password' | sha256sum
```
Полученный хеш вставляем в поле "sentry/password_sha256_hex"

Из примеров https://github.com/Altinity/clickhouse-operator/tree/master/docs/chi-examples делаем конфиг для clickhouse
Затем применяем его
```shell
kubectl apply -f kind-ClickHouseInstallation.yaml
```
Ждем когда появятся 3 пода chi-sentry-clickhouse-sharded-x-0-0.
Ждем когда все pod перейдут в состояние Running.
Ждем когда все поды Clickhouse найдут друг друга и Clickhouse перестанет писать в логи ошибки ServerErrorHandler или Cannot resolve host.
Чтобы увидеть логи Clickhouse, можно использовать stern для просмотра логов в namespace sentry.
```
stern -n sentry -l clickhouse.altinity.com/chi=sentry-clickhouse
```

Устанавливаем sentry.
```shell
helm repo add sentry https://sentry-kubernetes.github.io/charts
helm repo update
helm install sentry -n sentry sentry/sentry --version 23.1.0 -f values-sentry.yaml
```

Ждем Clickhouse миграции в pod snuba-migrate.
Ждем завершения PostgreSQL миграции в pod db-init-job.
Чтобы увидеть лог миграции snuba-migrate, можно использовать stern для просмотра логов в namespace sentry.
```
stern -n sentry -l job-name=sentry-snuba-migrate
```

Чтобы увидеть лог миграции db-init, можно использовать stern для просмотра логов в namespace sentry.
```
stern -n sentry -l job-name=sentry-db-init
```
Открываем URL, прописанный в system.url.
Входим в sentry по кредам, которые вы указали в этом коде.
```
user:
  password: "пароль"
  create: true
  email: логин-в-виде-email
```

Создаем project, выбираем python.
Создаем директорию example-python.
Переходим в директорию example-python.
В директории example-python создаем main.py такого содержания.
```shell
import sentry_sdk
sentry_sdk.init(
    dsn="http://xxxx@sentry.apatsev.org.ru/2",
    traces_sample_rate=1.0,
)

try:
    1 / 0
except ZeroDivisionError:
    sentry_sdk.capture_exception()
```

```shell
python3 -m venv venv
source venv/bin/activate
pip install --upgrade sentry-sdk
```
В Sentry видим следующую картину
![](capture_exception.png)
