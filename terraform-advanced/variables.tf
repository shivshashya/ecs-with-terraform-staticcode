#Writing variables can be done using going from resource by resource and adding variables
variable "environment" {
  description = "The deployment envoironment (dev,staging, prod)"
  type        = string
  #default     = "dev"
}

#I like to add the project name in my terrform code
variable "project" {
  description = "The project name"
  type        = string
  default     = "augustbootcamp-studentportal"
}

variable "app" {
  description = "The application name"
  type        = string
  default     = "studentportalapp"
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]
}


variable "rds_defaults" {
  default = {
    allocated_storage     = 20
    max_allocated_storage = 50
    storage_type          = "gp3"
    engine                = "postgres"
    engine_version        = "14.15"
    instance_class        = "db.t3.micro"
    username              = "postgres"
  }
}

variable "ecs_app_values" {
  type        = map(string)
  description = "values for ecs application"

  default = {
    container_name = "stugentportal"
    container_port = "8000"
    host_port      = "8000"
    memory         = "512"
    launch_type    = "FARGATE"
    domain_name    = "shivshashya.shop"
    subdomain_name = "studentportal"
  }

}