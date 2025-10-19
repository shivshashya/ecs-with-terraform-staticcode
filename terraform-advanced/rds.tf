# RDS instance
resource "aws_db_instance" "postgres" {
  identifier                 = "${var.environment}-${var.app}-db"
  allocated_storage          = tonumber(var.rds_defaults["allocated_storage"])
  max_allocated_storage      = tonumber(var.rds_defaults["max_allocated_storage"])
  engine                     = var.rds_defaults["engine"]
  engine_version             = var.rds_defaults["engine_version"]
  instance_class             = var.rds_defaults["instance_class"]
  username                   = var.rds_defaults["username"]
  password                   = random_password.rds_password.result
  db_name                    = "postgres"
  skip_final_snapshot        = true
  publicly_accessible        = false
  vpc_security_group_ids     = [aws_security_group.rds.id]
  ca_cert_identifier         = "rds-ca-rsa2048-g1"
  db_subnet_group_name       = aws_db_subnet_group.rds_subnet.id
  multi_az                   = false
  storage_encrypted          = true
  kms_key_id                 = data.aws_kms_key.rds_kms.arn
  port                       = 5432
  backup_retention_period    = 7
  auto_minor_version_upgrade = true
  deletion_protection        = false
  copy_tags_to_snapshot      = true

  tags = {
    Name        = "Postgres-DB"
    Environment = "dev"
    Terraform   = "true"
  }

  lifecycle {
    ignore_changes = [password]
  }

}

# RDS subnet group => put both rds subnets into it
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "${var.environment}-${var.app}-subnet-group"
  subnet_ids = [aws_subnet.rds_1.id, aws_subnet.rds_2.id]
}

#RDS security groups (inbound port 5432 from ECS SG only)
resource "aws_security_group" "rds" {
  name        = "${var.environment}-${var.app}-rds-sg"
  description = "Allow inbound traffic PostgreSQL from ECS only"
  vpc_id      = aws_vpc.main.id

  #Inbound rule from ecs sg only
  ingress {
    description     = "Postgres from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_service_sg.id]
  }

  #Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-${var.app}-db-security-group"
  }

}


#KMS key for encrytion at rest 

#Username and pasword for RDS using secret manager

# KMS key for encryption at rest - 1 per environmnet
# We will be using data source for this
# resource "aws_kms_key" "rds_keys" {
#     description              = "KMS key for RDS"
#     deletion_window_in_days  = 7
#     rotation_period_in_days  = 30
#     enable_key_rotation      = true
# }


# Create a password for the RDS instance -> Randowm provider
resource "random_password" "rds_password" {
  length           = 10
  special          = false
  override_special = "abcdefghjkmnpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
}

# Store the password in secret manager
resource "aws_secretsmanager_secret" "db_link" {
  name                    = "db/${aws_db_instance.postgres.identifier}"
  description             = "DB link"
  kms_key_id              = data.aws_kms_key.rds_kms.arn
  recovery_window_in_days = 7
  lifecycle {
    create_before_destroy = true
  }
}

# Create secret
resource "aws_secretsmanager_secret_version" "db_link_version" {
  secret_id = aws_secretsmanager_secret.db_link.id
  secret_string = jsonencode({
    #db_link = "postgresql://{username}:{password}@{endpoint}:{port}/{dbname}"
    db_link = "postgresql://${aws_db_instance.postgres.username}:${random_password.rds_password.result}@${aws_db_instance.postgres.address}:${aws_db_instance.postgres.port}/${aws_db_instance.postgres.db_name}"
  })
  depends_on = [aws_db_instance.postgres]
}
