## Отчет о выполнении дипломного практикума. С.Г. Комаров

### Оглавление:

1. [Создание облачной инфраструктуры](#one)  
2. [Создание Kubernetes кластера](#two)  
3. [Создание тестового приложения](#three)  
4. [Подготовка cистемы мониторинга и деплой приложения](#four)  
5. [Установка и настройка CI/CD](#five)  

Ссылка на репозиторий с исходным кодом проекта: https://github.com/komaroff-ski/devops-diplom  




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

5. Создаем инфраструктуру:  

```
terraform workspace set stage
terraform plan
terraform apply

terraform workspace set prod
terraform plan
terraform apply
``` 

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
Выполняем установку:
```
kubectl apply --server-side -f manifests/setup
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
kubectl apply -f manifests/
```

Убедимся что все поды и сервисы поднялись:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/c5c948fc-00e1-4fc9-84af-26c67041fac4)  
 
Опубликуем Grafana наружу с помощью port-forward:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/69526ac0-5e17-47aa-8f42-e0ffb3e1203b)  

Зайдем на Grafana и убедимся что метрики получаются и визуализируются:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/df13dd5f-a0aa-429c-bbf3-fd701c0ea375)  

2. Задеплоим тестовое приложение на кластер при помощи qbec. 

Приготовим конфигурацию qbec для prod-среды: https://github.com/komaroff-ski/devops-diplom/blob/main/qbec/stage/components/nginx.jsonnet  

Запустим валидацию конфигурации:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/7fd3a8b9-112a-4436-9ffd-beb968096d37)  

Задеплоим приложение и убедимся что все работает:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/78cac1f1-abeb-42e3-82eb-34c9cb313f66)

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/55840f41-ca43-48eb-b91e-b566896ad088)


### Установка и настройка CI/CD  
<a name="five"></a>

В качестве CI/CD будем использовать Managed Service for GitLab от Yandex.Cloud.  

С вашего позволения, я немного отошел от базового сценария с использованием qbec, и, в качестве эксперимента, для сборки приложения на stage-среду использовал связку kaniko +  gitlab-runner for kubernates, а для деплоя - образ kubectl.  

1. Добавим gitlab runner на kubernetes  

Зайдем в настройки CI/CD и скопируем регистрационный токен:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/e202f9d3-f766-48c0-8c22-df61cb9926b2)  

Для установки и регистрации раннера, на мастере нашего кластера выполним команду:  

```
helm install gitlab-runner --namespace ng-app   --set gitlabUrl=https://ksggit.gitlab.yandexcloud.net   --set runnerRegistrationToken=GR1348941B1t5YuyCUoFzVs_Bz12o   --set rbac.create=true   gitlab/gitlab-runner
```

Зайдем в интерфейс gitlab и убедимся что runner зарегистрирован и готов к работе  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/e9ed3166-a3c9-4ecf-9e23-8148be41117f)  

Создадим переменные, которые будут необходимы для выполнения скриптов:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/1ff988fa-ef4c-4e35-abba-2d29e319701c)  

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

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/12d54715-b7bb-48e2-99c8-733d475f79ea)  

2. Внесем изменения в код и сделаем коммит. Посмотрим jobs:  

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/8edca3e6-42d8-4364-8aef-797a7cf37ff1)  


4. Запушим тег и посмотрим jobs:  

build:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/da30e12c-e139-436d-9c01-bd4a3a8789c5)


deploy:  
![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/deff4786-8561-42ae-9449-c93491af286c)


6. Убедимся, что теперь работает новая версия приложения:

![image](https://github.com/komaroff-ski/devops-diplom/assets/93157702/be772282-5994-4e08-b95a-431695ced0e5)  



