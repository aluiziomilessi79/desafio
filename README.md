# Desafio (Docker e Terraform) - Aluizio Milessi

Esse desafio tem como objetivo garantir o que todos adoramos: ser preguiçosos!

Entregável

- (1) Rodar um comando e garantir que a sua aplicação está rodando nas nossas máquinas locais.
- (2) Rodar um (ou não muitos mais) comando(s) e subir a sua aplicação em um ambiente na AWS.


## Estrutura de diretório

```
Desafio
|--- README.md
|--- docker
     |--- docker-compose.yml
     |--- app
          |--- Dockerfile
          |--- site
               |--- index.html
               |--- sie-pagarme.fld
                    |--- colorschememapping.xml
                    |--- filelist.xml
                    |--- header.html
                    |--- image001.png
                    |--- image002.png
                    |--- themedata.thmx                    
|--- terraform
     |--- Beanstalk-Custom-Network
          |--- main.tf
          |--- outputs.tf
          |--- policy.tf
          |--- variables.tf
          |--- provider.tf
          |--- version.tf
          |--- terraform.tfvars
          |--- latest.zip
     |--- Beanstalk-Full
          |--- main.tf
          |--- outputs.tf
          |--- policy.tf
          |--- variables.tf
          |--- provider.tf
          |--- version.tf
          |--- terraform.tfvars
          |--- latest.zip
```


## (1) Entregável - Estrutura de arquivos - docker - Teste da Aplicação Local

| Arquivo e Pasta | Descrição |
|------|---------|
| docker-compose.yml | arquivo que constroi o ambiente e roda localmente em um servidor ou em uma maquina local. |
| Dockerfile | arquivo utilizado para gerar uma imagem docker customizada. |
| site | pasta dos arquivos da aplicação que será gerada dentro de uma imagem docker, onde poderá ser customizada de acordo com a necessidade. |

## Docker versões

Docker version 20.10.6 e acima são suportados.

Docker-Compose version 1.29.1 e acima são suportados.

Link: https://docker.com

## Como executar o deploy com um único comando
## Execução com o Docker-Compose
OBS: Dentro da pasta "docker", utilize o passo abaixo e teste localmente seu preguiçoso. 

```
$ docker-compose up

Docker Compose is now in the Docker CLI, try `docker compose up`

Creating network "docker_default" with the default driver
Building webapp
Sending build context to Docker daemon  562.2kB
Step 1/7 : FROM nginx:alpine
alpine: Pulling from library/nginx
97518928ae5f: Pull complete 
a4e156412037: Pull complete 
e0bae2ade5ec: Pull complete 
3f3577460f48: Pull complete 
e362c27513c3: Pull complete 
a2402c2da473: Pull complete 
Digest: sha256:12aa12ec4a8ca049537dd486044b966b0ba6cd8890c4c900ccb5e7e630e03df0
Status: Downloaded newer image for nginx:alpine
 ---> b46db85084b8
Step 2/7 : RUN mkdir /usr/share/nginx/html/sie-pagarme.fld
 ---> Running in 36da903af008
Removing intermediate container 36da903af008
 ---> 5010cd60a80e
Step 3/7 : COPY ./site/sie-pagarme.fld/* /usr/share/nginx/html/sie-pagarme.fld/
 ---> ffedbd7bbd58
Step 4/7 : COPY ./site/index.html /usr/share/nginx/html/
 ---> f06ff883d689
Step 5/7 : EXPOSE 80
 ---> Running in 5c9ba9d9c4f7
Removing intermediate container 5c9ba9d9c4f7
 ---> 90906d42c291
Step 6/7 : ARG buildno
 ---> Running in bf0ec2ad9edf
Removing intermediate container bf0ec2ad9edf
 ---> fdc02b568e25
Step 7/7 : RUN echo "Build number: $buildno"
 ---> Running in e8113f497c1d
Build number: 1
Removing intermediate container e8113f497c1d
 ---> 71fa7a292249
Successfully built 71fa7a292249
Successfully tagged webapp:aluizio

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
WARNING: Image for service webapp was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating docker_webapp_1 ... done
Attaching to docker_webapp_1
webapp_1  | /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
webapp_1  | /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
webapp_1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
webapp_1  | 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
webapp_1  | 10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
webapp_1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
webapp_1  | /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
webapp_1  | /docker-entrypoint.sh: Configuration complete; ready for start up
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: using the "epoll" event method
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: nginx/1.21.4
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: built by gcc 10.3.1 20210424 (Alpine 10.3.1_git20210424) 
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: OS: Linux 5.10.25-linuxkit
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: start worker processes
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: start worker process 33
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: start worker process 34
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: start worker process 35
webapp_1  | 2021/12/27 15:45:46 [notice] 1#1: start worker process 36
webapp_1  | 172.19.0.1 - - [27/Dec/2021:15:46:03 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36" "-"
```

Agora é só abrir o browser como Google Chrome, Mozila, Firefox ou Edge e colocar na URL: http://localhost e pronto !!!

Sua aplicação abrirá !!!

Depois disso volte na linha de comando que está em execução e execute o comando CTRL+C para parar. 

INFO ADICIONAL: Você poderá usa o mesmo comando com a opção "-d". Exemplo: docker-compose up -d (essa opção roda em background, mas será necessário executar o comando: docker-compose down para parar o serviço, após os testes)


## (2) Entregável - Estrutura de arquivos do módulo terraform

| Arquivo | Descrição |
|------|---------|
| main.tf | arquivo de determina os serviços da AWS que serão criados no processo. |
| outputs.tf | arquivo que determina a saída de informações pós-execução. |
| variables.tf | arquivo com variáveis padrões para execução no Terraform, onde poderá ser customizada de acordo com a necessidade. |
| policy.tf | arquivo que determina o recurso de política que será aplicada nos serviços da AWS, onde poderá ser customizada de acordo com a necessidade. |
| provider.tf | arquivo que determina o recurso e seus componentes que serão utilizado no processo de execução. |
| version.tf | arquivo que determina a versão das biblioteca do terraform a serem utilizada na execução. |
| terraform.tfvars | arquivo que declara algumas variáveis que será utilizado na criação do recurso. |
| latest.zip | arquivo que contém o Dockerrun.aws.json específico do beanstalk da aplicação |

## Terraform versões

Terraform 0.14.7 e acima são suportados.

Terraform v1.1.2 (Mac) e acima são suportados.

Link: https://www.terraform.io/downloads

## Como executar o deploy desse módulo
## Requesitos necessários para execução

| Name | Version |
|------|---------|
| terraform | >= 0.14.7 |
| awscli | >= 1.0 |

## Configure AWS CLI
OBS: Configuração utilizada para deploy da infraestrutura foi na região N.Virginia - US-EAST-1 

Será necessário uma conta na AWS com usuário contendo uma permissão adequada para a criação da aplicação.

Link: https://aws.amazon.com/pt/cli/

```
$ aws configure

AWS Access Key ID: XXXXXXXXX
AWS Secret Access Key: YYYYYYYYYYYYYYYYY
Default region name [us-east-1]: XXXXXX
Default output format [json]: YYYY
```

## Execução com Terraform
OBS: dentro da pasta "terraform" onde colocou o código existem duas pastas!

(1) Pasta "Beanstalk-Full" para preguiçoso , cria toda infraestrutura na AWS.

(2) Pasta "Beanstalk-Custom-Network" só será usada, caso a conta da AWS já exista uma configuração de network (VPC,Subnet,Route,etc) implementada. Para isso será necessário colocar algumas informações simples, mas é para preguiçoso também.

## Na pasta Beanstalk-Full para preguiçoso master high

### Criação da Infraestrutura
```
$ terraform init

Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/time from the dependency lock file
- Using previously-installed hashicorp/aws v3.32.0
- Using previously-installed hashicorp/time v0.7.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```
$ terraform plan
```

```
$ terraform apply
```

### Remoção da Infraestrutura

```
$ terraform destroy
```

## Utilize apenas os procedimentos abaixo, caso tenha uma infraestrutura de rede na AWS.

## Na pasta Beanstalk-Custom-Network para preguiçoso master low

### Dentro do arquivo "terraform.tfvars" edite e troque os parâmetros abaixo, de acordo com o seu ambiente.

```
$ vi terraform.tfvars
```

```
vpc_id              = "vpc-xxxxxxxxxxxxx" # VPC Network
public_subnets      = ["subnet-zzzzzzzzzzz", "subnet-vvvvvvvvvvv"] # Service Subnet
elb_public_subnets  = ["subnet-bbbbbbbbbbb", "subnet-aaaaaaaaaaa"] # ELB Subnet 
```

### Criação da Infraestrutura Customizada
```
$ terraform init

Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/time from the dependency lock file
- Using previously-installed hashicorp/aws v3.32.0
- Using previously-installed hashicorp/time v0.7.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```
$ terraform plan
```

```
$ terraform apply
```

### Remoção da Infraestrutura Customizada

```
$ terraform destroy
```


## Outputs

| Name | Description |
|------|-------------|
| tier | Tipo do serviço da aplicação no beanstalk |
| name | Nome da config aplicada na aplicação no beanstalk |
| application | Nome da aplicação criada no beanstalk |
| s3\_bucket\_id | Nome do bucket criado - Ex: desafio20211227142234917100000001|
| s3\_bucket\_object\_id | Nome do objeto (arquivo) realizado o upload para ser usado no beanstalk - Ex: latest.zip |
| endpoint\_url | Endereço do ALB para validar a aplicação no browser - Ex: awseb-AWSEB-XXXXXXXXX-0000000.us-east-1.elb.amazonaws.com |

OBS: Após a criação o OUTPUTS exibirá apenas as variáveis acima, lembra que somos preguiçosos.

Agora é só abrir o browser como Google Chrome, Mozila, Firefox ou Edge e colocar na URL: http://awseb-AWSEB-XXXXXXXXX-0000000.us-east-1.elb.amazonaws.com e pronto !!!


## Authors

[Aluizio Milessi] (https://github.com/aluiziomilessi).

