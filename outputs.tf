output "arn" {
  description = "ARN of the lambda function"
  value       = local.enabled ? module.lambda.arn : null
}

output "invoke_arn" {
  description = "Invoke ARN of the lambda function"
  value       = local.enabled ? module.lambda.invoke_arn : null
}

output "qualified_arn" {
  description = "ARN identifying your Lambda Function Version (if versioning is enabled via publish = true)"
  value       = local.enabled ? module.lambda.qualified_arn : null
}

output "function_name" {
  description = "Lambda function name"
  value       = local.enabled ? module.lambda.function_name : null
}

output "role_name" {
  description = "Lambda IAM role name"
  value       = local.enabled ? module.lambda.role_name : null
}

output "role_arn" {
  description = "Lambda IAM role ARN"
  value       = local.enabled ? module.lambda.role_arn : null
}
