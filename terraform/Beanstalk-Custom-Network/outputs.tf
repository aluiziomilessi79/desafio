# Configuracoes de saida dos resultados apos o processo de criacao beanstalk

output "s3_bucket_id" {
  value = aws_s3_bucket.default.id
}

output "s3_bucket_object_id" {
  value = aws_s3_bucket_object.default.id
}

output "name" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.name
}

output "tier" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.tier
}

output "application" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.application
}

output "endpoint_url" {
  value = aws_elastic_beanstalk_environment.beanstalkappenv.endpoint_url
}