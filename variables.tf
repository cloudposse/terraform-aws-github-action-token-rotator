variable "function_name" {
  type    = string
  default = "GitHubRunnerTokenRotator"
}

variable "memory_size" {
  description = "Amount of memory in MB the Lambda Function can use at runtime."
  default     = 512
  type        = number
}

variable "function_description" {
  type    = string
  default = "An app that automatically rotates the GitHub Action Runner token and stores it in SSM Parameter Store"
}

variable "parameter_store_token_path" {
  type        = string
  description = "Path to store the token in parameter store"
}

variable "parameter_store_private_key_path" {
  type        = string
  description = "Path to read the GitHub App private key from parameter store"
}

variable "github_app_id" {
  type        = string
  description = "GitHub App ID"
}

variable "github_app_installation_id" {
  type        = string
  description = "GitHub App Installation ID"
}

variable "github_org" {
  type        = string
  description = "GitHub Organization"
}

variable "schedule_expression" {
  type        = string
  description = "AWS Schedule Expression: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html"
  default     = "rate(30 minutes)"
}

variable "lambda_zip_version" {
  description = "The version of the Lambda function to deploy"
  default     = "0.1.0"
  type        = string
}
