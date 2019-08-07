
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
