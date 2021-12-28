# Variaveis que sera utilizada no processo de criacao do beanstalk

variable "elasticapp" {
  default = "webapp"
  description = "Nome especifico para o beanstalk, deve ser unico!"
}

variable "beanstalkappenv" {
  default = "webappenv" 
  description = "Nome especifico para o conjunto de parametros utilizado no ambiente do beanstalk" 
}

variable "solution_stack_name" {
  type = string
  description = "Tipo da plataforma que sera utilizada no ambiente do beanstalk" 
}

variable "tier" {
  type = string
  description = "Tipo da aplicacao utilizada no ambiente do beanstalk"
}

variable "instancetype" { 
  type = string
  description = "Tipo da instacia utilizada para executar o ambiente do beanstalk"
}

variable "vpc_id" {}
variable "minsize" {}
variable "maxsize" {}
variable "public_subnets" {}
variable "elb_public_subnets" {}


# Variaveis declaradas a serem utilizadas na criacao do recurso S3
# As mesma podem ser customizadas !

variable "bucket_prefix" {
    type        = string
    description = "Nome especifico para o bucket, deve ser unico!"
    default     = ""
}

variable "acl" {
    type        = string
    description = "ACL predefinida"
    default     = "public-read"
}

variable "versioning" {
    type        = bool
    description = "Controle de versao."
    default     = true
}

variable "force_destroy" {
    type        = bool
    description = "Permite a exclusao do bucket , mesmo nao estando vazio"
    default     = true
}

variable "tags" {
    type        = map
    description = "Mapeamento de TAGs para atribuir ao bucket"
    default     = {
        environment = "desafio"
        terraform   = "true"
    }
}