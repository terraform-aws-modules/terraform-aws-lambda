output "codedeploy_app_name" {
  description = "Name of CodeDeploy application"
  value       = local.app_name
}

output "codedeploy_deployment_group_name" {
  description = "CodeDeploy deployment group name"
  value       = local.deployment_group_name
}

output "codedeploy_deployment_group_id" {
  description = "CodeDeploy deployment group id"
  value       = element(concat(aws_codedeploy_deployment_group.this.*.id, [""]), 0)
}

output "codedeploy_iam_role_name" {
  description = "Name of IAM role used by CodeDeploy"
  value       = element(concat(aws_iam_role.codedeploy.*.name, [""]), 0)
}

output "appspec" {
  description = "Appspec data as HCL"
  value       = local.appspec
}

output "appspec_content" {
  description = "Appspec data as valid JSON"
  value       = local.appspec_content
}

output "appspec_sha256" {
  description = "SHA256 of Appspec JSON"
  value       = local.appspec_sha256
}

output "script" {
  description = "Deployment script"
  value       = local.script
}

output "deploy_script" {
  description = "Path to a deployment script"
  value       = element(concat(local_file.deploy_script.*.filename, [""]), 0)
}
