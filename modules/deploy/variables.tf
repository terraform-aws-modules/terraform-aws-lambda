variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "alias_name" {
  description = "Name for the alias"
  type        = string
  default     = ""
}

variable "function_name" {
  description = "The name of the Lambda function to deploy"
  type        = string
  default     = ""
}

variable "current_version" {
  description = "Current version of Lambda function version to deploy (can't be $LATEST)"
  type        = string
  default     = ""
}

variable "target_version" {
  description = "Target version of Lambda function version to deploy"
  type        = string
  default     = ""
}

variable "before_allow_traffic_hook_arn" {
  description = "ARN of Lambda function to execute before allow traffic during deployment"
  type        = string
  default     = ""
}

variable "after_allow_traffic_hook_arn" {
  description = "ARN of Lambda function to execute after allow traffic during deployment"
  type        = string
  default     = ""
}

#########################
# CodeDeploy Application
#########################

variable "create_app" {
  description = "Whether to create new AWS CodeDeploy app"
  type        = bool
  default     = false
}

variable "use_existing_app" {
  description = "Whether to use existing AWS CodeDeploy app"
  type        = bool
  default     = false
}

variable "app_name" {
  description = "Name of AWS CodeDeploy application"
  type        = string
  default     = ""
}

##############################
# CodeDeploy Deployment Group
##############################

variable "create_deployment_group" {
  description = "Whether to create new AWS CodeDeploy Deployment Group"
  type        = bool
  default     = false
}

variable "use_existing_deployment_group" {
  description = "Whether to use existing AWS CodeDeploy Deployment Group"
  type        = bool
  default     = false
}

variable "deployment_group_name" {
  description = "Name of deployment group to use"
  type        = string
  default     = ""
}

variable "deployment_config_name" {
  description = "Name of deployment config to use"
  type        = string
  default     = "CodeDeployDefault.LambdaAllAtOnce"
}

########################
# CodeDeploy Deployment
########################

variable "save_deploy_script" {
  description = "Save deploy script locally"
  type        = bool
  default     = false
}


variable "create_deployment" {
  description = "Run AWS CLI command to create deployment"
  type        = bool
  default     = false
}

