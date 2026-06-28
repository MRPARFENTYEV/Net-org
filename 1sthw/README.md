# Домашнее задание: Организация сети

Terraform-конфигурация для развёртывания сетевой инфраструктуры в Yandex Cloud (обязательная часть) и AWS (дополнительная часть).

## Структура репозитория

```
.
├── yandex/          # Задание 1 — Yandex Cloud
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── terraform.tfvars.example
├── aws/             # Задание 2 — AWS (опционально)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── terraform.tfvars.example
└── README.md
```

## Предварительные требования

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3
- [Yandex Cloud CLI (`yc`)](https://yandex.cloud/ru/docs/cli/quickstart) с настроенным профилем
- SSH-ключ (`~/.ssh/id_rsa` и `~/.ssh/id_rsa.pub`)
- Для AWS (опционально): [AWS CLI](https://aws.amazon.com/cli/) с настроенными credentials

### Настройка доступа Yandex Cloud

```bash
yc init
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

## Задание 1. Yandex Cloud

### Что создаётся

| Ресурс | Описание |
|--------|----------|
| `yandex_vpc_network` | Пустая VPC `hw15-vpc` |
| `yandex_vpc_subnet` `public` | Подсеть `192.168.10.0/24` |
| `yandex_vpc_subnet` `private` | Подсеть `192.168.20.0/24` |
| `yandex_vpc_route_table` | Маршрут `0.0.0.0/0` → NAT (`192.168.10.254`) |
| `yandex_compute_instance` `nat` | NAT-инстанс с image `fd80mrhj8fl2oe87o4e1`, IP `192.168.10.254` |
| `yandex_compute_instance` `public` | ВМ в public-подсети с публичным IP |
| `yandex_compute_instance` `private` | ВМ в private-подсети с внутренним IP |

Манифесты: [yandex/main.tf](yandex/main.tf)

### Развёртывание

```bash
cd yandex
cp terraform.tfvars.example terraform.tfvars
# Отредактируйте folder_id в terraform.tfvars

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
![img_10.png](img_10.png)  
![img_11.png](img_11.png)  
![img_12.png](img_12.png)  
![img_13.png](img_13.png)



### Проверка

#### 1. Публичная ВМ — доступ в интернет

```bash
# Получить IP
terraform output public_vm_public_ip

# Подключиться
ssh ubuntu@<PUBLIC_VM_IP>

# На ВМ
curl -s ifconfig.me
ping -c 3 8.8.8.8
```
![img_14.png](img_14.png)  
<!-- TODO: вставить скриншот curl/ping с public-vm -->

#### 2. Приватная ВМ — доступ в интернет через NAT

```bash
# Получить команду подключения
terraform output ssh_private_vm_via_public

# Подключиться через jump host (public-vm)
ssh -J ubuntu@<PUBLIC_VM_IP> ubuntu@<PRIVATE_VM_IP>

# На приватной ВМ
curl -s ifconfig.me   # должен вернуть публичный IP NAT-инстанса
ping -c 3 8.8.8.8
```

![img_15.png](img_15.png)  

