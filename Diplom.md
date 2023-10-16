## Отчет о выполнении дипломного практикума. С.Г. Комаров

### Создание облачной инфраструктуры

1. Для выполнения задачи использую созданный ранее сервисный аккаунт sa-terraform:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/896f7b91-af03-4908-8a96-1a4e5d293410)

2. Для хранения базы состояний terraform создаем S3 бакет на yandex.cloud:

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/deac702e-c0a7-4b0a-9447-6ebe7e3d397f)  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/7ec20c1c-e44e-4c91-92ae-aed93587d43f)

3. Теперь все готово для создания инфраструктуры для наших кластеров. При помощи terraform создадим два окружения: stage и prod

- ссылка на код terraform для создания окружения: https://github.com/komaroff-ski/devops-diplom/tree/main/infra

- Состав инфраструктуры для обоих сред идентичный: 1 мастер и 2 воркера  

4. Создаем 2 workspaces:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/8b4e7216-67cf-4659-b4ec-6429de3904f2)

5. Делаем terraform plan чтобы убедиться в отсутствии ошибок и корректности применяемых настроек:

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/36763208-18c6-4e28-a656-e6fe682ec59f)

6. Создаем инфраструктуру (на примере контура prod):  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/93c6a3fa-eb79-40cf-a46c-c53eb887b366)


![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/88989066-8d48-49ee-a9fe-cb2643908db2)


7. Готово. Заходим в консоль Яндекс.Облака чтобы убедиться, что инфраструктура создана корректно:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/a8f17658-7e1a-48e7-b679-641e317bd061)



### Создание Kubernetes кластера

Для создания Kubernetes кластера в обоих средах будем использовать kubespray.

1. Готовим inventory следующим образом:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/10976e2e-41bd-4c8b-8773-b419279d968c)

2. Добавляем внешние адреса кластера в файл hosts локальной машины (где выполняется kubespray):  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/82b27c99-f7e6-4249-b093-44ad55d2074c)


3. Делаем необходимые настройки в файлах k8s-cluster.yml, addons.yml, all.yml и запускаем установку кластера:

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/cff8ca15-6d9b-4b5b-b381-4665f3613f99)

4. Установка выполнена:
 ![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/7886ba17-d9fe-4eab-9863-425c98fecdfa)

6. Заходим на мастер и проверяем работоспособность кластера:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/35b13013-6b41-4d1f-86bc-a12c553b075f)

7. Реквизиты доступа к кластеру:

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/6f678c57-aeca-4f4d-a80f-1b07857e6d7f)


### Создание тестового приложения

В качестве тестового приложения будем использовать простой nginx-сервер со статическим контентом. Приложение упаковано в docker-контейнер и выложено в регистр DockerHub

Ссылка на Dokerfile: https://github.com/komaroff-ski/devops-diplom/blob/main/ng-app/Dockerfile  
Ссылка на регистр приложения: https://hub.docker.com/repository/docker/komaroffski/ng-app/general

### Подготовка cистемы мониторинга и деплой приложения

1. Деплоим в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes. Для решения данной задачи возмользуемся пакетом kube-prometheus:

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/26251df0-d0c9-41d9-9e8f-bbd39cfd575e)

Убедимся что все поды и сервисы поднялись:

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/f150e231-94c5-499a-aa60-2eee0a6f7bd4)  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/95d28f6a-770e-4023-956a-4c2d17801065)  

Опубликуем Grafana наружу с помощью port-forward:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/9cee8827-b449-4778-b6ea-fcb2bd028de4)

Зайдем на Grafana и убедимся что метрики получаются и визуализируются:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/6f40ca2f-9bb9-4637-8546-49fd8814dd92)  




