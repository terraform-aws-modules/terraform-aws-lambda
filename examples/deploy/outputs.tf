output "codedeploy_app_name" {
  description = "Name of CodeDeploy application"
  value       = module.deploy.codedeploy_app_name
}

output "codedeploy_deployment_group_name" {
  description = "CodeDeploy deployment group name"
  value       = module.deploy.codedeploy_deployment_group_name
}

output "codedeploy_deployment_group_id" {
  description = "CodeDeploy deployment group id"
  value       = module.deploy.codedeploy_deployment_group_id
}

output "codedeploy_iam_role_name" {
  description = "Name of IAM role used by CodeDeploy"
  value       = module.deploy.codedeploy_iam_role_name
}

output "appspec" {
  description = "Appspec data as HCL"
  value       = module.deploy.appspec
}

output "appspec_content" {
  description = "Appspec data as valid JSON"
  value       = module.deploy.appspec_content
}

output "appspec_sha256" {
  description = "SHA256 of Appspec JSON"
  value       = module.deploy.appspec_sha256
}

output "script" {
  description = "Deployment script"
  value       = module.deploy.script
}

output "deploy_script" {
  description = "Path to a deployment script"
  value       = module.deploy.deploy_script
}
