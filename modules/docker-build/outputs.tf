output "image_uri" {
  description = "The ECR image URI for deploying lambda"
  value       = docker_registry_image.this.name
}
