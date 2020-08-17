
# Antes de rodar
Garantir o acesso a AWS configurando via variável de ambiente, credential profile ou role. O script ```configure.sh``` vai checar o acesso rodando um ```aws eks list```

# Instalação
```
git clone https://github.com/AlexsanderAR/aws_eks.git
cd aws_eks
./configure.sh
```

# Selectionar uma workspace [dev | hlg | prd]
```
terraform wrokspace select dev
```

# Criar cluster
```
terraform apply -auto-approve
```

# Destruir cluster
```
terraform destroy -auto-approve
```
