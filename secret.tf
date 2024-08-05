resource "random_password" "master" {
  length  = 20
  special = false
}

locals {
  #endpoint = module.rds_proxy.proxy_endpoint
  endpoint = module.aurora_postgresql_v2_primary.cluster_endpoint
  identifier = module.aurora_postgresql_v2_primary.cluster_instances["one"].id
 
  endpoint_reader = module.aurora_postgresql_v2_secondary.cluster_endpoint
  #endpoint_reader = module.rds_proxy_secondary.db_proxy_endpoints["read_write"].endpoint
  identifier_reader = module.aurora_postgresql_v2_secondary.cluster_instances["one"].id
}


resource "aws_secretsmanager_secret" "db_pass" {
  name = "${var.platform_name}-${random_pet.this.id}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "db_pass_sec" {
  name = "${var.platform_name}-${random_pet.this.id}"
  recovery_window_in_days = 0

  provider = aws.region2
}


resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.db_pass.id #pim360
  secret_string = <<EOF
    {
    "password": "${random_password.master.result}", 
    "dbname": "pim360", 
    "engine": "postgres", 
    "port": 5432, 
    "dbInstanceIdentifier": "${local.identifier}", 
    "host": "${local.endpoint}", 
    "username": "${var.database_username}",
    "endpoint": "postgresql://t360:${random_password.master.result}@${local.endpoint}/pim360"
    }
  EOF
}

resource "aws_secretsmanager_secret_version" "example_sec" {
  secret_id     = aws_secretsmanager_secret.db_pass_sec.id #pim360
  provider = aws.region2
  secret_string = <<EOF
    {
    "password": "${random_password.master.result}", 
    "dbname": "pim360", 
    "engine": "postgres", 
    "port": 5432, 
    "dbInstanceIdentifier": "${local.identifier}", 
    "host": "${local.endpoint_reader}", 
    "username": "${var.database_username}",
    "endpoint": "postgresql://t360:${random_password.master.result}@${local.endpoint_reader}/pim360"
    }
  EOF
}