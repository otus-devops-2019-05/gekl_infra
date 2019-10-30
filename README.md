
# Выполнено Занятие №11 (ANSIBLE-2)
## gekl_infra [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=ansible-2)](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=master)

    [*] Создание плейбука для настройки и деплоя приложения и БД
    [*] Создание одного плейбука для нескольких сценариев
    [*] Создание нескольких плейбуков
    [*] Использование готовых Dynamic Inventory (*)
    [*] Провижининг в Packer

### Создание плейбука для настройки и деплоя приложения и БД
    
    В этом способе у нас один плейбук и мы запускаем его на разных хостах с помощью опций --limit, а так же ограничиваем исполнение через --tags

#### Настройка базы данных modgoDB

```shell
ansible-playbook reddit_app.yml --limit db --tags db-tag
```
#### Настройка инстанса приложения

```shell
ansible-playbook reddit_app.yml --limit app --tags app-tag
```
#### Деплой приложения

```shell
ansible-playbook reddit_app.yml --limit app --tags deploy-tag
```
### Создание одного плейбука для нескольких сценариев
#### Сценарий для mongoDB
```shell
ansible-playbook reddit_app2.yml --tags db-tag
```
#### Сценарий для App
```shell
ansible-playbook reddit_app2.yml --tags app-tag
```
#### Сценарий для деплоя приложения
```shell
ansible-playbook reddit_app2.yml --tags deploy-tag
```
### Создание нескольких плейбуков
Созадим app.yml, db.yml и deploy.yml и site.yml в который импортируем 3 созданных плейбука.

```shell
ansible-playbook site.yml
```
### Использование готовых Dynamic Inventory (*)

```shell
pip install requests
pip install google-auth
gcloud iam service-accounts keys create ~/ansible_gcp_key.json --iam-account ansible@infra-249015.iam.gserviceaccount.com
```
Добавляем в `ansible.cfg`  плагин:

```
[inventory]
enable_plagins = gcp_compute
```
И пишем yml файл для inventry, после чего добавляем его в ansible.cfg

### Провижининг в Packer
Создадим 2 плейбука: 
- packer_app.yml
- packer_db.yml


# Выполнено Занятие №10 (ANSIBLE-1)
## gekl_infra [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=terraform-1)](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=master)

    [*] Основное задание
    [*] Задание со *

### В процессе сделано:

 - Установка Ansible
 - Знакомство с базовыми функциями и инвентори
 - Выполнение различных модулей на подготовленной в прошлых ДЗ инфраструктуре
 - Пишем простой плейбук
 - Написали скрипт парсящий стейтфайл терраформа и создающий на его основе json (принимает параметры --list --host для ansible)

#### Основное задание
 - Утановлен Ansible
 - Протестированы разные варианты его испльзования, написания inventory и cfg файла
 - Написан простой playbook для клонирования репозитория
 
#### Задание со*

На основе терраформ стейт файла, генерируется json файл, написанный скрипт указывается в cfg файле ansible.

# Выполнено Занятие №9 (TERRAFORM-2)
## gekl_infra [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=terraform-1)](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=master)

    [*] Основное задание
    [*] Самостоятельная работа
    [*] Задание со *
    [*] Задание со **

### В процессе сделано:

#### Основное задание
 - Выпонено задание по созданию инстанса
 - Добавление ssh ключа

#### Самостоятельная работа

Текущую конфигурацию terraform разбил на два модуля app и db, и создал модуль vpc для правил файрвола. В файле main.tf указываем откуда загружать модули [source]:

```
module "app" {
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.app_disk_image}"
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["${var.ip_access_range}"]
}

```
Модули загружаются с помощью команды `terraform get`
Разделил инфраструктуру на два окружения:
- stage
- prod

#### Задание со*
Для хранения текущего стейта настроил remote backend используя для этого GCS. Для создания GCS используется storage-bucket.tf после чего, происходит инициализация в stage и prod конфигурациях через terraform init. Если присутствовал локальный стейт - будет предложено его перенести в remote. Если будет выполнено одновременное обращение к стейту, то сработает блокировка.

#### Задание со**
Добавлены provisioner для app и db.

# Выполнено Занятие №8 ДЗ №1 (TERRAFORM-1)
## gekl_infra [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=terraform-1)](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=master)

    [*] Основное задание
    [*] Самостоятельная работа
    [*] Задание со *
    [*] Задание со **

### В процессе сделано:

#### Основное задание
 - Установлен terraform на рабочее место администратора
 - Выпонено задание по созданию инстанса
 - Добавление ssh ключа

#### Самостоятельная работа
 - Определена переменная для приватного ключа private_key_path = "~/.ssh/appuser"
 - Определена переменная для задания зоны
 - Произведена проверка файлов с помощью  terraform fmt
 - Создан файл terraform.tfvars.example

#### Задание со *
 - Создание ключа appuser1 в gcp
 - Описано добавление нескольких ключей
 - После добавление пользователя appuser_web и запуска terraformapply, данный пользователь затирается.
#### Задание со **
 - Создан файл lb.tf для генерации gcp load balancera
 - Добавлен код создания нескольких инстансов и счетчик  

# Выполнено Занятие №7 ДЗ №1 (PACKER)

## gekl_infra [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=packer-base)](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=master)

    [*] Основное задание
    [*] Самостоятельная работа
    [*] Дополнительное задание *

### В процессе сделано:

#### Основное задание
 - Установлен packer на рабочее место администратора
 - Настроена авторизация packer в gcp
 - Создан packer template (ubuntu16.json) со скриптами провижининга
 - С помошью packer произведена валидация файла ubuntu16.json
 - На основе него создан образ вм 
 - После создана вм и устанволен app

#### Самостоятельная работа
 - Создан файл переменных
 - В него спрятаны обязательные переменные и в файл добавлены переменные размера диска и tag firewall

```
{
    "variables":
        {
    "project_id": null,
    "source_image_family": null,
    "zone": null,
    "tags": null
        },
    "builders": [
        {
            "type": "googlecompute",
            "project_id": "{{user `project_id`}}",
            "image_name": "reddit-base-{{timestamp}}",
            "image_family": "reddit-base",
            "source_image_family": "{{user `source_image_family`}}",
            "zone": "{{user `zone`}}",
            "ssh_username": "appuser",
            "machine_type": "f1-micro",
            "disk_size": "16",
            "tags": "{{user `tags`}}"
        }
    ],
    "provisioners": [
        {
            "type": "shell",
            "script": "scripts/install_ruby.sh",
            "execute_command": "sudo {{.Path}}"
        },
        {
            "type": "shell",
            "script": "scripts/install_mongodb.sh",
            "execute_command": "sudo {{.Path}}"
        }
    ]
}

Пример файл переменных variables.json.example , реальный файл спрятан за .gitignore.
Для запуска используется 
packer build -var-file=./variables.json ./immutable.json

{
"project_id": "infra-111111",
"source_image_family": "ubuntu-1111-lts",
"zone": "us-west1-a",
"tags": "nike-server"
}
```
#### Дополнительное задание * 
 - Подготовлен файл immutable.json
```
{
    "variables":
        {
    "project_id": null,
    "source_image_family": null,
    "zone": null,
    "tags": null
        },
    "builders": [
        {
            "type": "googlecompute",
            "project_id": "{{user `project_id`}}",
            "image_name": "reddit-full-{{timestamp}}",
            "image_family": "reddit-full",
            "source_image_family": "{{user `source_image_family`}}",
            "zone": "{{user `zone`}}",
            "ssh_username": "appuser",
            "machine_type": "f1-micro",
            "disk_size": "16",
            "tags": "{{user `tags`}}"
        }
    ],
    "provisioners": [
        {
            "type": "shell",
            "script": "scripts/install_ruby.sh",
            "execute_command": "sudo {{.Path}}"
        },
        {
            "type": "shell",
            "script": "scripts/install_mongodb.sh",
            "execute_command": "sudo {{.Path}}"
        },
        {
            "type": "file",
            "source": "files/puma.service",
            "destination": "~/puma.service"
        },
        {
            "type": "shell",
            "script": "scripts/deploy.sh",
            "execute_command": "sudo {{.Path}}"
        }
    ]
}
```
 - Запуск инстанса на основе reddit-full)create-reddit-vm.sh)
 

# Выполнено Занятие №6 ДЗ №2 (GCP-2)

## gekl_infra [![Build Status](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=cloud-testapp)](https://travis-ci.com/otus-devops-2019-05/gekl_infra.svg?branch=master)

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
