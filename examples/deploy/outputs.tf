output "this_codedeploy_app_name" {
  description = "Name of CodeDeploy application"
  value       = module.deploy.this_codedeploy_app_name
}

output "this_codedeploy_deployment_group_id" {
  description = "CodeDeploy deployment group name"
  value       = module.deploy.this_codedeploy_deployment_group_id
}

output "codedeploy_iam_role_name" {
  description = "Name of IAM role used by CodeDeploy"
  value       = module.deploy.codedeploy_iam_role_name
}

output "appspec" {
  value = module.deploy.appspec
}

output "appspec_content" {
  value = module.deploy.appspec_content
}

output "appspec_sha256" {
  value = module.deploy.appspec_sha256
}

output "script" {
  value = module.deploy.script
}

output "deploy_script" {
  value = module.deploy.deploy_script
}
