output "this_codedeploy_app_name" {
  description = "Name of CodeDeploy application"
  value       = local.app_name
}

output "this_codedeploy_deployment_group_id" {
  description = "CodeDeploy deployment group name"
  value       = element(concat(aws_codedeploy_deployment_group.this.*.id, [""]), 0)
}

output "codedeploy_iam_role_name" {
  description = "Name of IAM role used by CodeDeploy"
  value       = element(concat(aws_iam_role.codedeploy.*.name, [""]), 0)
}

output "appspec" {
  value = local.appspec
}

output "appspec_content" {
  value = local.appspec_content
}

output "appspec_sha256" {
  value = local.appspec_sha256
}

output "script" {
  value = local.script
}

output "deploy_script" {
  value = element(concat(local_file.deploy_script.*.filename, [""]), 0)
}
