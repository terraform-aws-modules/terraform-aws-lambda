variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "use_existing_alias" {
  description = "Whether to manage existing alias instead of creating a new one. Useful when using this module together with external tool do deployments (eg, AWS CodeDeploy)."
  type        = bool
  default     = false
}

variable "refresh_alias" {
  description = "Whether to refresh function version used in the alias. Useful when using this module together with external tool do deployments (eg, AWS CodeDeploy)."
  type        = bool
  default     = true
}

variable "create_async_event_config" {
  description = "Controls whether async event configuration for Lambda Function/Alias should be created"
  type        = bool
  default     = false
}

variable "create_version_async_event_config" {
  description = "Whether to allow async event configuration on version of Lambda Function used by alias (this will revoke permissions from previous version because Terraform manages only current resources)"
  type        = bool
  default     = true
}

variable "create_qualified_alias_async_event_config" {
  description = "Whether to allow async event configuration on qualified alias"
  type        = bool
  default     = true
}

variable "create_version_allowed_triggers" {
  description = "Whether to allow triggers on version of Lambda Function used by alias (this will revoke permissions from previous version because Terraform manages only current resources)"
  type        = bool
  default     = true
}

variable "create_qualified_alias_allowed_triggers" {
  description = "Whether to allow triggers on qualified alias"
  type        = bool
  default     = true
}

########
# Alias
########

variable "name" {
  description = "Name for the alias you are creating."
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the alias."
  type        = string
  default     = ""
}

variable "function_name" {
  description = "The function ARN of the Lambda function for which you want to create an alias."
  type        = string
  default     = ""
}

variable "function_version" {
  description = "Lambda function version for which you are creating the alias. Pattern: ($LATEST|[0-9]+)."
  type        = string
  default     = ""
}

variable "routing_additional_version_weights" {
  description = "A map that defines the proportion of events that should be sent to different versions of a lambda function."
  type        = map(number)
  default     = {}
}

############################
# Lambda Async Event Config
############################

variable "maximum_event_age_in_seconds" {
  description = "Maximum age of a request that Lambda sends to a function for processing in seconds. Valid values between 60 and 21600."
  type        = number
  default     = null
}

variable "maximum_retry_attempts" {
  description = "Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2."
  type        = number
  default     = null
}

variable "destination_on_failure" {
  description = "Amazon Resource Name (ARN) of the destination resource for failed asynchronous invocations"
  type        = string
  default     = null
}

variable "destination_on_success" {
  description = "Amazon Resource Name (ARN) of the destination resource for successful asynchronous invocations"
  type        = string
  default     = null
}

############################################
# Lambda Permissions (for allowed triggers)
############################################

variable "allowed_triggers" {
  description = "Map of allowed triggers to create Lambda permissions"
  type        = map(any)
  default     = {}
}

############################################
# Lambda Event Source Mapping
############################################

variable "event_source_mapping" {
  description = "Map of event source mapping"
  type        = any
  default     = {}
}
