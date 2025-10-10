data "aws_eip" "by_allocation_id" {
  id = "eipalloc-0dd285858fcf56f2f"
}


data "aws_kms_key" "rds_kms" {
  key_id = "alias/ecsterraform/akhilashbootcamp"
}
# To use this particular ip
# data.aws_eip.by_allocation_id.id

data "aws_region" "current" {

}