output "image_uri" {
  description = "The ECR image URI for deploying lambda"
  value       = var.create_image ? docker_registry_image.lambda_image[0].name : var.image_uri
}
