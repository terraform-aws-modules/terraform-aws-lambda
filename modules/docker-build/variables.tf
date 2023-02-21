variable "create_ecr_repo" {
  description = "Controls whether ECR repository for Lambda image should be created"
  type        = bool
  default     = false
}

variable "ecr_address" {
  description = "Address of ECR repository for cross-account container image pulling (optional). Option `create_ecr_repo` must be `false`"
  type        = string
  default     = null
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

variable "ecr_force_delete" {
  description = "If true, will delete the repository even if it contains images."
  default     = true
  type        = bool
}

variable "ecr_repo_tags" {
  description = "A map of tags to assign to ECR repository"
  type        = map(string)
  default     = {}
}

variable "build_args" {
  description = "A map of Docker build arguments."
  type        = map(string)
  default     = {}
}

variable "ecr_repo_lifecycle_policy" {
  description = "A JSON formatted ECR lifecycle policy to automate the cleaning up of unused images."
  type        = string
  default     = null
}

variable "keep_remotely" {
  description = "Whether to keep Docker image in the remote registry on destroy operation."
  type        = bool
  default     = false
}

variable "platform" {
  description = "The target architecture platform to build the image for."
  type        = string
  default     = null
}
