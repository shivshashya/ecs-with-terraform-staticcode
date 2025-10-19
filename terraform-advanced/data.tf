# data "aws_eip" "by_allocation_id" {
#   id = "eipalloc-0dd285858fcf56f2f"
# }

# To use this particular ip
# data.aws_eip.by_allocation_id.id
#use this if already created or create a new one using aws_eip resource
data "aws_kms_key" "rds_kms" {
  key_id = "alias/${var.environment}-kms"
}

#data.aws_region.current.name
data "aws_region" "current" {}

#data.aws_caller_indentity.current.account_id
data "aws_caller_identity" "current" {}