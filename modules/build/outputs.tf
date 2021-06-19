output "image_uri" {
  value = var.create_image? docker_registry_image.lambda_image[0].name: var.image_uri
}
output "repository_id"{
  value = var.create_repo? aws_ecr_repository.this[0].id : local.ecr_name
}
