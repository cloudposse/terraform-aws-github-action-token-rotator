output "arn" {
  description = "ARN of the lambda function"
  value       = module.example.arn
}

output "invoke_arn" {
  description = "Invoke ARN of the lambda function"
  value       = module.example.invoke_arn
}

output "qualified_arn" {
  description = "ARN identifying your Lambda Function Version (if versioning is enabled via publish = true)"
  value       = module.example.qualified_arn
}

output "function_name" {
  description = "Lambda function name"
  value       = module.example.function_name
}

output "role_name" {
  description = "Lambda IAM role name"
  value       = module.example.role_name
}

output "role_arn" {
  description = "Lambda IAM role ARN"
  value       = module.example.role_arn
}
