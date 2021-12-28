# Configuracoes customizada para o ambiente no processo de criacao

vpc_id              = "vpc-xxxxxxxxxxxxx" # VPC Network
instancetype        = "t3.small"
minsize             = 1
maxsize             = 2
public_subnets      = ["subnet-zzzzzzzzzzz", "subnet-vvvvvvvvvvv"] # Service Subnet
elb_public_subnets  = ["subnet-bbbbbbbbbbb", "subnet-aaaaaaaaaaa"] # ELB Subnet
tier                = "WebServer"
solution_stack_name = "64bit Amazon Linux 2 v3.4.10 running Docker"
bucket_prefix       = "desafio"