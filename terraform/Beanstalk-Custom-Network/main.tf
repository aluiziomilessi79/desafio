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
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     =  "False"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnets)
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.elb_public_subnets)
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

