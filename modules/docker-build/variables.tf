variable "create_ecr_repo" {
  description = "Controls whether ECR repository for Lambda image should be created"
  type        = bool
  default     = false
}

variable "ecr_repo" {
  description = "Name of ECR repository to use or to create"
  type        = string
  default     = null
}

variable "image_tag" {
  description = "Image tag to use. If not specified current timestamp in format 'YYYYMMDDhhmmss' will be used. This can lead to unnecessary rebuilds."
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


variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = false
}

variable "ecr_repo_tags" {
  description = "A map of tags to assign to ECR repository"
  type        = map(string)
  default     = {}
}
