# Criação dos recurso de network VPC que sera utilizada no processo de criacao do beanstalk

locals {
  public_subnets = {
    "${var.region}a" = "10.0.0.0/24"
    "${var.region}b" = "10.0.1.0/24"    
  }
  private_subnets = {
    "${var.region}a" = "10.0.2.0/24"
    "${var.region}b" = "10.0.3.0/24"
  }
}

resource "aws_vpc" "VPC_teste" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  tags                 = var.tags
}

resource "aws_subnet" "Public_subnet" {
  vpc_id                  = aws_vpc.VPC_teste.id
  map_public_ip_on_launch = var.mapPublicIP 
  count                   = "${length(local.public_subnets)}"
  cidr_block              = "${element(values(local.public_subnets), count.index)}"
  availability_zone       = "${element(keys(local.public_subnets), count.index)}"
  tags                    = var.tags
}

resource "aws_subnet" "Private_subnet" {
  vpc_id                  = aws_vpc.VPC_teste.id
  count                   = "${length(local.private_subnets)}"
  cidr_block              = "${element(values(local.private_subnets), count.index)}"
  availability_zone       = "${element(keys(local.private_subnets), count.index)}"
  tags                    = var.tags
}

resource "aws_network_acl" "Public_NACL" {
  vpc_id = aws_vpc.VPC_teste.id
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.publicdestCIDRblock 
    from_port  = 22
    to_port    = 22
  }
   
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.publicdestCIDRblock
    from_port  = 22 
    to_port    = 22
  }  
  tags = var.tags
}

resource "aws_internet_gateway" "IGW_teste" {
 vpc_id = aws_vpc.VPC_teste.id
 tags   = var.tags
} 

resource "aws_default_route_table" "Public_RT" {
  default_route_table_id = "${aws_vpc.VPC_teste.main_route_table_id}"
  tags   = var.tags
}

resource "aws_route_table" "Private_RT" {
 vpc_id = aws_vpc.VPC_teste.id
 tags   = var.tags
}

resource "aws_route" "internet_access" {
  count                  = "${length(local.public_subnets)}"
  route_table_id         = "${aws_default_route_table.Public_RT.id}"
  destination_cidr_block = var.publicdestCIDRblock
  gateway_id             = aws_internet_gateway.IGW_teste.id
}

resource "aws_eip" "nat" {
  vpc = true
  tags   = var.tags
}

resource "aws_nat_gateway" "default" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.Public_subnet.0.id}"
  tags          = var.tags
}

resource "aws_route" "private_access" {
  route_table_id         = "${aws_route_table.Private_RT.id}"
  destination_cidr_block = var.publicdestCIDRblock
  nat_gateway_id         = "${aws_nat_gateway.default.id}"
}

resource "aws_route_table_association" "Public_association" {
  count          = "${length(local.public_subnets)}"
  subnet_id      = "${element(aws_subnet.Public_subnet.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.Public_RT.id}"
}

resource "aws_route_table_association" "Private_association" {
  count          = "${length(local.private_subnets)}"
  subnet_id      = "${element(aws_subnet.Private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.Private_RT.id}"
}
 

# Criacao do S3 onde sera armazenado a definicao da versao do app do elastic beanstalk utilizada.

resource "aws_s3_bucket" "default" {
  bucket_prefix = var.bucket_prefix  
  acl           = var.acl
  force_destroy = var.force_destroy

  versioning {
        enabled = var.versioning
  }

  tags = var.tags

}

resource "aws_s3_bucket_object" "default" {
  bucket = aws_s3_bucket.default.id
  key    = "latest.zip"
  source = "latest.zip"
  acl    = var.acl
}


# Criando aplicacao do elastic beanstalk na AWS

resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = var.elasticapp
  description = "desafio pagarme"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "desafio-web"
  application = aws_elastic_beanstalk_application.elasticapp.name
  description = "Application Desafio"
  bucket      = aws_s3_bucket.default.id
  key         = aws_s3_bucket_object.default.id
}

# Criando as variaveis do ambiente do elastic beanstalk 

resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  name                = var.beanstalkappenv
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = var.solution_stack_name
  tier                = var.tier
  version_label       = aws_elastic_beanstalk_application_version.default.name
  
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.VPC_teste.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     =  "False"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.Private_subnet.0.id},${aws_subnet.Private_subnet.1.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${aws_subnet.Public_subnet.0.id},${aws_subnet.Public_subnet.1.id}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instancetype
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.minsize
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.maxsize
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = "webapp_profile"
  }

}

