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
