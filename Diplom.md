## Отчет о выполнении дипломного практикума. С.Г. Комаров

### Оглавление:

1. [Создание облачной инфраструктуры](#one)
2. [Создание Kubernetes кластера]
3. [Создание тестового приложения]
4. [Подготовка cистемы мониторинга и деплой приложения]
5. [Установка и настройка CI/CD]

Ссылка на репозиторий со всем исходным кодом: https://github.com/komaroff-ski/devops-diplom  


### Создание облачной инфраструктуры  
<a name="one"></a>

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

Зайдем на web-интерфейс приложения:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/88989066-8d48-49ee-a9fe-cb2643908db2)  


7. Готово. Заходим в консоль Яндекс.Облака чтобы убедиться, что инфраструктура создана корректно:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/a8f17658-7e1a-48e7-b679-641e317bd061)  



### Создание Kubernetes кластера  
<a name="two"></a>

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
<a name="three"></a>
В качестве тестового приложения будем использовать простой nginx-сервер со статическим контентом. Приложение упаковано в docker-контейнер и выложено в регистр DockerHub  

Ссылка на Dokerfile: https://github.com/komaroff-ski/devops-diplom/blob/main/ng-app/Dockerfile  
Ссылка на регистр приложения: https://hub.docker.com/repository/docker/komaroffski/ng-app/general  

### Подготовка cистемы мониторинга и деплой приложения  
<a name="four"></a>

1. Деплоим в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes. Для решения данной задачи возмользуемся пакетом kube-prometheus:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/26251df0-d0c9-41d9-9e8f-bbd39cfd575e)  

Убедимся что все поды и сервисы поднялись:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/f150e231-94c5-499a-aa60-2eee0a6f7bd4)  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/95d28f6a-770e-4023-956a-4c2d17801065)  

Опубликуем Grafana наружу с помощью port-forward:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/9cee8827-b449-4778-b6ea-fcb2bd028de4)  

Зайдем на Grafana и убедимся что метрики получаются и визуализируются:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/6f40ca2f-9bb9-4637-8546-49fd8814dd92)  

2. Задеплоим тестовое приложение на кластер при помощи qbec:  

Приготовим конфигурацию qbec для prod-среды: 

Запустим валидацию конфигурации:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/15dfc86b-def3-406a-a40f-d4172fb7edf6)  

Задеплоим приложение и убедимся что все работает:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/7d1d883f-5395-4857-84d0-c845b0161d19)  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/cd17d841-12e7-4d30-aa48-331db64f285c)  



### Установка и настройка CI/CD  
<a name="five"></a>

В качестве CI/CD будем использовать Managed Service for GitLab от Yandex.Cloud.  

С вашего позволения, я немного отошел от базового сценария с использованием qbec, и, в качестве эксперимента, для сборки приложения на stage-среду использовал связку kaniko +  gitlab-runner for kubernates, а для деплоя - образ kubectl.  

1. Добавим gitlab runner на kubernetes  

Зайдем в настройки CI/CD и скопируем регистрационный токен:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/567fc9a2-b24e-48b4-8a49-14f49c0801ab)  

Для установки и регистрации раннера, на мастере нашего кластера выполним команду:  

```
helm install gitlab-runner --namespace ng-app   --set gitlabUrl=https://ksggit.gitlab.yandexcloud.net   --set runnerRegistrationToken=GR1348941B1t5YuyCUoFzVs_Bz12o   --set rbac.create=true   gitlab/gitlab-runner
```

Зайдем в интерфейс gitlab и убедимся что runner зарегистрирован и готов к работе  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/d92cffe9-d9b2-44db-ade6-ad0ccacc7e02)


Создадим переменные, которые будут необходимы для выполнения скриптов:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/0038e0db-557c-4db5-930e-c36c95c1900e)

KUBECONFIG - конфигурация для доступа к нашему кластеру  
MY_REGISTRY - index.docker.io  
MY_REGISTRY_PASSWORD и MY_REGISTRY_USER - реквизиты доступа к регистру  

Сконфигурируем pipeline следующим образом:  
a. При любом коммите происходит сборка образа и отправка в dockerhub c тегом, содержащий короткий хэш коммита
b. в случае, когда происходит коммит с тегом:
-  мы собираем образ и отправляем его в dockerhub с соотвествующим тегом, а так же его копию с тегом latest
-  делаем деплой нашего приложения в кластер с использованием kubectl
-  принудительно перезапускаем под. т.к. для контейнера приложения мы применяем политику imagePullPolicy: Always, в случае, если версия latest изменила свой хэш, кластер принудительно обновит образ из регистра.  

Ссылка на файл gitlab-ci: https://github.com/komaroff-ski/devops-diplom/blob/main/ng-app/.gitlab-ci.yml  

Демонстрация работы:  

1. Исходная версия приложения:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/0a693742-2a1b-4d34-8fbb-38243a45987a)

2. Внесем изменения в код и сделаем коммит:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/0e6a95f0-fa8a-4739-b250-4deb60b638d9) 

3. Посмотрим jobs  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/6eec7e3a-9219-4be0-9555-74b3d493b20a)  

4. Запушим тег  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/82ff43ca-e92f-4f1e-ad70-c6a4a867654a)  

5. Посмотрим jobs  

build:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/72ecbda3-4c42-458e-ad94-9703050bb148)


deploy:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/cfb71d72-3b01-4cb4-b965-2168286118a2)

6. Убедимся, что теперь работает новая версия приложения:

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/df49e8e5-7546-46d7-98de-7bdbe6c60f52)


