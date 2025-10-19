#IAM role for ECS task execution - 1st step
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.environment}-ecs-august-task-execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

#IAM policy document for ECS task execution role - 2nd step
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#role attachments with aws policies - 3rd step
resource "aws_iam_role_policy_attachment" "eccs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



