variable "create_ecr_repo" {
  description = "Controls whether ECR repository for Lambda image should be created"
  type        = bool
  default     = false
}

variable "create_sam_metadata" {
  description = "Controls whether the SAM metadata null resource should be created"
  type        = bool
  default     = false
}

variable "use_image_tag" {
  description = "Controls whether to use image tag in ECR repository URI or not. Disable this to deploy latest image using ID (sha256:...)"
  type        = bool
  default     = true
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

variable "builder" {
  description = "The buildx builder to use for the Docker build."
  type        = string
  default     = null
}

variable "build_args" {
  description = "A map of Docker build arguments."
  type        = map(string)
  default     = {}
}

variable "build_target" {
  description = "Set the target build stage to build"
  type        = string
  default     = null
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

variable "force_remove" {
  description = "Whether to remove image forcibly when the resource is destroyed."
  type        = bool
  default     = false
}

variable "keep_locally" {
  description = "Whether to delete the Docker image locally on destroy operation."
  type        = bool
  default     = false
}

variable "triggers" {
  description = "A map of arbitrary strings that, when changed, will force the docker_image resource to be replaced. This can be used to rebuild an image when contents of source code folders change"
  type        = map(string)
  default     = {}
}

variable "cache_from" {
  description = "List of images to consider as cache sources when building the image."
  type        = list(string)
  default     = []
}
