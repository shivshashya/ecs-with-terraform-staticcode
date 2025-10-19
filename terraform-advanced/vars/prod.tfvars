environment = "prod"
app = "studentportal"


rds_default {
    allocated_storage       = "50"
    max_allocated_storage   = "100"
    storage_type            = "gp3"
    engine                  = "postgres"
    engine_version          = "14.15"
    instance_class          = "db.t3.medium"
    username                = "postgres"
}