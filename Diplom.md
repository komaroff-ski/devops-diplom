## Отчет о выполнении дипломного практикума. С.Г. Комаров

### Оглавление:

1. [Создание облачной инфраструктуры](#one)  
2. [Создание Kubernetes кластера](#two)  
3. [Создание тестового приложения](#three)  
4. [Подготовка cистемы мониторинга и деплой приложения](#four)  
5. [Установка и настройка CI/CD](#five)  

Ссылка на репозиторий со всем исходным кодом: https://github.com/komaroff-ski/devops-diplom  




### Создание облачной инфраструктуры  
<a name="one"></a>

1. Для выполнения задачи использую созданный ранее сервисный аккаунт sa-terraform:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/1643ce13-645c-4ae0-b1c1-bf486075ff1f)  

2. Для хранения базы состояний terraform создаем S3 бакет на yandex.cloud:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/529fe36b-9194-407e-ace3-efb789c42b78)  

3. Теперь все готово для создания инфраструктуры для наших кластеров. При помощи terraform создадим два окружения: stage и prod  

- ссылка на код terraform для создания окружения: https://github.com/komaroff-ski/devops-diplom/tree/main/infra  

- Состав инфраструктуры для обоих сред идентичный: 1 мастер и 2 воркера  

4. Создаем 2 workspaces (stage и prod):  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/9367577e-1fb5-4b96-869b-ed1300eca0c9)  

5. Создаем инфраструктуру (на примере контура prod):  

'''
terraform workspace set stage
terraform plan
terraform apply

terraform workspace set prod
terraform plan
terraform apply
''' 

6. Готово. Заходим в консоль Яндекс.Облака чтобы убедиться, что инфраструктура создана корректно:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/2b6cbf34-cd36-404f-93e4-dfa098579250)  


### Создание Kubernetes кластера  
<a name="two"></a>

Для создания Kubernetes кластера в обоих средах будем использовать kubespray.  

1. Готовим inventory следующим образом:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/2f05c244-f495-427c-b9c1-d280ec63f7c2)  
 
2. Добавляем внешние адреса кластера в файл hosts локальной машины (где выполняется kubespray):  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/dbe20f16-6d80-4bbd-b070-85645185d44f)  

3. Делаем необходимые настройки в файлах k8s-cluster.yml, addons.yml, all.yml и запускаем установку кластера.
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/032b2748-28d1-4d20-a6b3-3c2f68930abf)  

4. Заходим на мастер и проверяем работоспособность кластера:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/225d1dda-afcd-4d95-a44b-cf3106d7766c)  

7. Реквизиты доступа к кластеру:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/b63c9797-b0a8-4fed-8dc8-4abd0afa2f22)  


### Создание тестового приложения  
<a name="three"></a>
В качестве тестового приложения будем использовать простой nginx-сервер со статическим контентом. Приложение упаковано в docker-контейнер и выложено в регистр DockerHub  

Ссылка на Dokerfile: https://github.com/komaroff-ski/devops-diplom/blob/main/ng-app/Dockerfile  
Ссылка на регистр приложения: https://hub.docker.com/repository/docker/komaroffski/ng-app/general  

### Подготовка cистемы мониторинга и деплой приложения  
<a name="four"></a>

1. Деплоим в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes. Для решения данной задачи возмользуемся пакетом kube-prometheus.
Выполняем установку при помощи команд:
```

```



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


