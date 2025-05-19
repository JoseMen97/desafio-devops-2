# Terraform AWS VPC

## Descripción

Este proyecto configura una VPC en AWS con 3 subnets públicas y 3 subnets privadas, un Internet Gateway, y un NAT Gateway.

## Requisitos

- Terraform >= 1.4.0
- Proveedor de AWS >= 5.0
- Credenciales de AWS configuradas.

## Uso

1. Clona este repositorio.
2. Crea un archivo `terraform.tfvars` con los valores necesarios. Ejemplo:

```
aws_region     = "us-east-1"
vpc            = "10.0.0.0/16"
public_subnet  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
```

3. Inicializa terrform con el siguiente comando:

```
terraform init
```

4. Revisa el plan de cambios a aplicar con el siguiente comando:

```
terraform plan -var-file="terraform.tfvars" -out=terraformplan
```

5. Aplica los cambios con el siguiente comando:

```
terraform apply -var-file="terraform.tfvars" terraformplan
```
