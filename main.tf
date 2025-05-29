locals {
  enabled                         = module.this.enabled
  region_name                     = local.enabled ? data.aws_region.this[0].name : null
  account_id                      = local.enabled ? data.aws_caller_identity.this[0].account_id : null
  bucket                          = local.enabled ? format("cplive-core-%s-public-lambda-artifacts", module.utils.region_az_alt_code_maps.to_fixed[local.region_name]) : null
  artifact_path                   = format("lambda-github-action-token-rotator/lambda-github-action-token-rotator-%s.zip", var.lambda_zip_version)
  parameter_store_token_arn       = local.enabled ? format("arn:aws:ssm:%s:%s:parameter%s", local.region_name, local.account_id, var.parameter_store_token_path) : null
  parameter_store_private_key_arn = local.enabled ? format("arn:aws:ssm:%s:%s:parameter%s", local.region_name, local.account_id, var.parameter_store_private_key_path) : null
}

module "utils" {
  enabled = local.enabled
  source  = "cloudposse/utils/aws"

  context = module.this.context
}

data "aws_caller_identity" "this" {
  count = local.enabled ? 1 : 0
}
data "aws_region" "this" {
  count = local.enabled ? 1 : 0
}

module "label" {
  count      = local.enabled ? 1 : 0
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = [var.function_name]

  context = module.this.context
}

module "lambda" {
  enabled = local.enabled
  source  = "cloudposse/lambda-function/aws"
  version = "0.6.1"

  function_name = local.enabled ? module.label[0].id : null
  description   = var.function_description
  publish       = true

  s3_bucket = local.bucket
  s3_key    = local.artifact_path

  lambda_environment = {
    variables = {
      "AWS_PARAM_STORE_TOKEN_PATH" = var.parameter_store_token_path
      "GITHUB_APP_ID"              = var.github_app_id
      "GITHUB_INSTALLATION_ID"     = var.github_app_installation_id
      "GITHUB_ORG"                 = var.github_org
      "GITHUB_PRIVATE_KEY"         = local.enabled ? module.parameter_store_private_key[0].values[0] : null
    }
  }

  memory_size = var.memory_size
  runtime     = "nodejs16.x"
  handler     = "main.handler"

  context = module.this.context
}

data "aws_iam_policy_document" "allow_ssm_parameter_store" {
  count = local.enabled ? 1 : 0

  statement {
    sid = "AllowSSMParamRead"
    actions = [
      "ssm:GetParameter",
    ]
    resources = [
      local.parameter_store_private_key_arn,
    ]
  }

  statement {
    sid = "AllowSSMParamWrite"
    actions = [
      "ssm:PutParameter",
    ]

    resources = [
      local.parameter_store_token_arn,
    ]
  }
}
resource "aws_iam_policy" "allow_ssm_parameter_store" {
  count       = local.enabled ? 1 : 0
  name        = module.label[0].id
  path        = "/"
  description = "Policy to allow lambda to read and write from ssm parameter store"

  policy = data.aws_iam_policy_document.allow_ssm_parameter_store[0].json
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = local.enabled ? 1 : 0
  role       = module.lambda.role_name
  policy_arn = aws_iam_policy.allow_ssm_parameter_store[0].arn
}

module "parameter_store_private_key" {
  count   = local.enabled ? 1 : 0
  source  = "cloudposse/ssm-parameter-store/aws"
  version = "0.10.0"

  parameter_read = [var.parameter_store_private_key_path]
  context        = module.this.context
}

resource "aws_cloudwatch_event_rule" "this" {
  count               = local.enabled ? 1 : 0
  name                = module.label[0].id
  schedule_expression = var.schedule_expression
  tags                = module.this.tags
}

resource "aws_cloudwatch_event_target" "this" {
  count = local.enabled ? 1 : 0
  rule  = aws_cloudwatch_event_rule.this[0].name
  arn   = module.lambda.arn
}

resource "aws_lambda_permission" "this" {
  count         = local.enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudwatchEvent"
  action        = "lambda:InvokeFunction"
  function_name = local.enabled ? module.label[0].id : null
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this[0].arn

}
