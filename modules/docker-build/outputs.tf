output "image_uri" {
  description = "The ECR image URI for deploying lambda"
  value       = var.use_image_tag ? docker_registry_image.this.name : format("%v@%v", docker_registry_image.this.name, docker_registry_image.this.id)
}

output "image_id" {
  description = "The ID of the Docker image"
  value       = docker_registry_image.this.id
}
