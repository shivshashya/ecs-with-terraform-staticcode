environment = "dev"
app = "studentportal"

rds_defaenvironment = "dev"

rds_defaults = {
  allocated_storage       = 20
  max_allocated_storage   = 50
  storage_type            = "gp3"
  engine                  = "postgres"
  engine_version          = "14.15"
  instance_class          = "db.t3.micro"
  username                = "postgres"
}