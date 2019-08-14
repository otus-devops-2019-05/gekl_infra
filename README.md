# Выполнено Занятие №6 ДЗ №2 (GCP-2)

## gekl_infra [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=cloud-testapp)](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=master)

    [*] [Деплой тествого приложения](#gcp2)
    [*] Самостоятельная работа
    [*] Дополнительное задание startupscript
    [*] Дополнительное задание firewall  

### В процессе сделано:

 - Установил и настроил gcloud для работы с моим аккаунтом;
 - Создал хост с помощью gcloud;
 - Установил на нем ruby для работы приложения;
 - Установил MongoDB, запустил и enable службу Mongo;
 - Задеплоид тестовое приложение, запустил и проверил его работу.
 - 
<a name="#gcp2"><h4>Парметры ВМ</h4></a>

testapp_IP = 35.247.57.26

testapp_port = 9292

<h4>Описание действий</h4>

<a name="#task5"><h5> Установил и настроил gcloud для работы с моим аккаунтом</h5></a>
Использую ВМ CentOS
```
$sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
$yum update
$yum install google-cloud-sdk
$gcloud init
```
Далее по инструкции, с проблемами и ошибками не столкнулся.
```
$gcloud auth list
 Credentialed Accounts
 ACTIVE  ACCOUNT
 *       mail@klepach.com
```

<a name="#task6"><h5>Создал хост с помощью gcloud</h5></a>
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
```
Аналогично без проблем 
```
$gcloud compute instances list | grep reddit-app

reddit-app  us-west1-a  g1-small                   10.138.0.5   35.247.57.26  RUNNING
```

<a name="#task7"><h5>Выполнил оставшиеся пункты установки службы и приложения</h5></a>
```
$sudo apt update
$sudo apt install -y ruby-full ruby-bundler build-essential

$sudo rm /etc/apt/sources.list.d/mongodb*.list
$sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E52529D4
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list'
$sudo apt update
$sudo apt install -y mongodb-org
$sudo systemctl start mongod
$sudo systemctl enable mongod
$systemctl status mongod
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-08-14 08:25:49 UTC; 2h 4min ago
$cd ~
$git clone -b monolith https://github.com/express42/reddit.git
$cd reddit
$bundle install
$puma -d
$ps aux | grep puma | grep 9292
gk       20617  0.0  2.3 652632 40380 ?        Sl   08:26   0:03 puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
```
Добавили правило tcp 9292 на файрволл gcp


После эти команды заверул в скрипты deploy.sh,install_mongodb.sh, install_ruby.sh
```
chmod +x *.sh
```
<a name="#task10"><h5>Дополнительное задание startupscript, дополнительное задание firewall</h5></a>

Создал новый скрипт на основе предыдущих *.sh, добавил storage bucket и добавил этот файл startupscript.sh в бакет.
Для создания правила fw, инстанса, установки ПО и его запуска.
```
$gcloud compute firewall-rules \
create default-puma-server \
--action allow \
--target-tags puma-server \
--source-ranges 0.0.0.0/0 \
--rules TCP:9292

$gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--metadata startup-script-url=gs://startupscripts-infra-249015/startupscript.sh \

```
Проверил, все ок.


PR checklist

    [x] Выставил label с номером домашнего задания
    [x] Выставил label с темой домашнего задания

Д

---
# Выполнено Занятие №5 ДЗ №1 (GCP)

## gekl_infra [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=master)](https://travis-ci.com/otus-devops-2019-05/gekl_infra)

    [*] [Знакомство с облачной инфраструктурой. Google Cloud Platform](#gcp)
    [*] Задание со *

### В процессе сделано:

- Создан аккаунт в [GCP](https://cloud.google.com/ "GCP link")
- Установлен ключ SSH
- Запущен инстанс bastion, имеющий внешний ip
- Запущен инстанс internalhost, не имеющий внешний ip
- [Настроен доступ к internalhost через bastion vm](#task5)
- [Подключения к internalhost в одну команду](#task6)
- [Подключение к internalhost по команде: ssh internalhost](#task7)
- [Установлен и настроен VPN-сервер для серверов CGP, порт udp 15472](#task8)
- [Настроен и протестирован доступ с локальной машины по ssh на хост internalhost через VPN тоннель](#task9)
- [Создан и поключен ssl сертификат для веб-интерфейса Pritunl](#task10)

<a name="#gcp"><h4>Парметры ВМ</h4></a>

bastion_IP = 35.247.9.23

someinternalhost_IP = 10.138.0.4


user gk

port : 22

vm list:
- bastion
    - external IP : 35.247.9.23
    - internal IP : 10.138.0.3
- internalhost
    - internalip : 10.138.0.4

<h4>Описание действий</h4>

<a name="#task5"><h5> Настроен доступ к internalhost через bastion vm</h5></a>
```
ssh-add ~/.ssh/id_rsa
ssh-add -L
notebook$ ssh -A 35.247.9.23
gk@bastion:~$ ssh 10.138.0.4
```

<a name="#task6"><h5>Подключения к internalhost в одну команду</h5></a>
```
ssh -At  gk@35.247.9.23 ssh 10.138.0.4
```
<a name="#task7"><h5>Подключение к internalhost по команде: ssh internalhost</h5></a>
Настраиваем файл .ssh/config
```
Host internalhost
  HostName 10.138.0.4
  ProxyCommand ssh -W %h:%p bastion
Host bastion
  Hostname 35.247.9.23
```
<a name="#task8"><h5>Установлен и настроен VPN-сервер для серверов CGP, порт udp 18121</h5></a>

<a name="#task9"><h5>Настроен и протестирован доступ с локальной машины по ssh на хост internalhost через VPN тоннель</h5></a>

<a name="#task10"><h5>Создан и поключен ssl сертификат для веб-интерфейса Pritunl</h5></a>
https://35.247.9.23.sslip.io

PR checklist

    [x] Выставил label с номером домашнего задания
    [x] Выставил label с темой домашнего задания

---
# Выполнено ДЗ №2 (GIT2)
## gekl_infra git2 [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=play-travis)](https://travis-ci.com/otus-devops-2019-05/gekl_infra)

    [*] Основное ДЗ
    [*] Задание со *

В процессе сделано:

    Скронирована репа gekl-infra
    git clone https://gekl@github.com/otus-devops-2019-05/gekl_infra.git
    Создан branch play-travis
    git checkout -b play-travis
    созданы файлы юнит-тестов и конфигурация Travis CI
    создан канал и интеграция с Travis CI
    https://devops-team-otus.slack.com/messages/CM2BK644X #george_klepach
    настроена авторизация с Travis CI
    исправлен юнит тест

Как запустить проект:

    Перейти по ссылке https://travis-ci.com/otus-devops-2019-05/gekl_infra/builds/122121978 нажать кнопку restart build

Как проверить работоспособность:

    По ссылке можно проверить выполнение тестов travis (https://travis-ci.com/otus-devops-2019-05/gekl_infra)

PR checklist

    [*] Выставил label с номером домашнего задания
    [*] Выставил label с темой домашнего задания
