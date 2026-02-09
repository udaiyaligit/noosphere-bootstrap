data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.project}-${var.environment}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_policy" "ssm_read" {
  name = "${var.project}-${var.environment}-ssm-read"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"],
        Effect   = "Allow",
        Resource = "arn:aws:ssm:${var.region}:*:parameter/${var.environment}/${var.project}/db_password"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ssm_read.arn
}

# Note: For least-privilege, narrow the Resource ARN to the exact SSM parameter name in a prod setup.
