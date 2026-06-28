# Домашнее задание: Вычислительные мощности. Балансировщики нагрузки

Terraform-конфигурация для Yandex Cloud. Продолжает инфраструктуру из [1sthw](../1sthw/README.md).

## Структура

```
2ndhw/
└── yandex/
    ├── network.tf          # data sources — VPC из 1sthw
    ├── storage.tf          # бакет + картинка
    ├── instance_group.tf   # группа ВМ LAMP + NLB
    ├── templates/          # cloud-init для index.html
    └── assets/picture.png  # файл для загрузки в бакет
```

## Что создаётся

| Ресурс | Описание |
|--------|----------|
| `yandex_storage_bucket` | Бакет Object Storage с публичным чтением |
| `yandex_storage_object` | Картинка в бакете |
| `yandex_compute_instance_group` | 3 ВМ LAMP (`fd827b91d99psvq5fjit`) в public-подсети |
| `yandex_lb_network_load_balancer` | Сетевой балансировщик на порту 80 |

## Предварительные требования

1. Развёрнута сеть из **1sthw** (`hw15-vpc`, subnet `public`):

```bash
cd ../1sthw/yandex
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
terraform apply
```

2. Переменные окружения для Terraform (в том же или новом терминале).

3. **Роль для Object Storage** — вашему Yandex-аккаунту нужна роль `storage.editor` на каталог:
   - [Консоль](https://console.cloud.yandex.ru/) → каталог **default** → **Права доступа** → **Назначить роли**
   - Выберите свой аккаунт → роль **`storage.editor`** → **Сохранить**

   Без этой роли `terraform apply` выдаст `AccessDenied` при создании бакета.

## Развёртывание

```bash
cd 2ndhw/yandex
cp terraform.tfvars.example terraform.tfvars
# Укажите уникальное имя бакета bucket_name (глобально уникальное!)
```

```bash
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

terraform init
terraform plan
terraform apply
```
![img.png](img.png)
![img_1.png](img_1.png)  
![img_2.png](img_2.png)
![img_3.png](img_3.png)  
![img_4.png](img_4.png)  
![img_5.png](img_5.png) 
![img_6.png](img_6.png)  
![img_7.png](img_7.png)  
![img_8.png](img_8.png)
![img_9.png](img_9.png) 

## Проверка

### 1. Картинка в Object Storage

```bash
terraform output image_public_url
curl -I $(terraform output -raw image_public_url)
```  
![img_10.png](img_10.png)
![img_11.png](img_11.png)  


### 2. Сайт через балансировщик

```bash
terraform output check_website
curl $(terraform output -raw check_website)
```
![img_12.png](img_12.png)  
На странице должна быть ссылка на картинку из бакета.
Удалил одну вм.Группа автоматически восстановливает размер до 3 ВМ. Сайт через NLB должен продолжать работать:
  
### 3. Проверка отказоустойчивости NLB
![img_13.png](img_13.png)  
![img_14.png](img_14.png)  
![img_15.png](img_15.png)  
![img_16.png](img_16.png)
![img_17.png](img_17.png)  

```bash
curl $(terraform output -raw check_website)
```

## Удаление ресурсов

```bash
cd 2ndhw/yandex
terraform destroy
```

Затем при необходимости:

```bash
cd ../../1sthw/yandex
terraform destroy
```
![img_18.png](img_18.png)  
![img_19.png](img_19.png)  

