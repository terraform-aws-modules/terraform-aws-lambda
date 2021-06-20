variable "create_image" {
  description = "Controls whether Lambda image should be created"
  type        = bool
  default     = false
}

variable "create_repo" {
  description = "Controls whether Lambda image repository should be created"
  type        = bool
  default     = false
}

variable "image_uri" {
  description = "The ECR image URI containing the function's deployment package."
  type        = string
  default     = null
}

variable "image_repo" {
  description = "Lambda function image repository name"
  type        = string
  default     = null
}

variable "image_tag" {
  description = "Lambda function image tag"
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
