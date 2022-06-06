module "rds_role" {
  environment  = var.environment
  company_name = var.company_name
  tags         = var.tags
  source       = "../src/modules/simple/iam_role"
  role_name    = "rds"
  service      = "rds.amazonaws.com"
  policy       = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroups"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF
}

module "eks_task_role" {
  environment  = var.environment
  company_name = var.company_name
  tags         = var.tags
  source       = "../src/modules/simple/iam_role"
  role_name    = "eks-tasks"
  service      = "eks.amazonaws.com"
  policy       = data.aws_iam_policy_document.task.json
}

data "aws_iam_policy_document" "task" {
  dynamic "statement" {
    for_each = var.server_iam_role_policy_statements
    content {
      effect    = statement.value["effect"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
    }
  }

  // Allow role to publish to SQS
  statement {
    effect    = "Allow"
    actions   = ["sqs:*"]
    resources = [module.sqs.arn]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "${module.server_docs_bucket.bucket_arn}/*",
      module.server_docs_bucket.bucket_arn
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeTags", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "eks" {
  count    = var.deploy_eks == true ? 1 : 0
  name = "${var.environment}-eks"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}