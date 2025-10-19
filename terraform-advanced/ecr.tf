#create ecr repository to store docker image
resource "aws_ecr_repository" "ecr" {
  name = "${var.environment}-${var.app}"
  #Use in production it will make you more money to aws
  #   image_scanning_configuration {
  #     scan on_push = true
}


