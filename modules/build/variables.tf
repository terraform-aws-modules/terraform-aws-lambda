variable "create_repo" {
  description = "Controls whether Lambda image repository should be created"
  type        = bool
  default     = false
}

variable "image_repo" {
  description = "Lambda function image repository name"
  type        = string
  default     = null
}

variable "image_tag" {
  description = "Lambda function image tag. When null it will be replaced with timestamp in format: 'YYYYMMDDhhmmss'"
  type        = string
  default     = null
}

variable "source_path" {
  description = "Path to folder containing application code"
  type        = string
  default     = null
}

variable "docker_file_path" {
  description = "Path to Dockerfile in source package"
  type        = string
  default     = "Dockerfile"
}
