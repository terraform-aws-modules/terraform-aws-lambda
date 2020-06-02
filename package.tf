# Generates a filename for the zip archive based on the content of the files
# in source_path. The filename will change when the source code changes.
data "external" "archive_prepare" {
  count = var.create && var.create_package ? 1 : 0

  program     = ["python", "${path.module}/lambda.py", "prepare"]
  working_dir = path.cwd

  query = {
    paths = jsonencode({
      module = path.module
      root   = path.root
      cwd    = path.cwd
    })

    docker = var.build_in_docker ? jsonencode({
      docker_file    = var.docker_file
      docker_image   = var.docker_image
      with_ssh_agent = var.docker_with_ssh_agent
    }) : null

    artifacts_dir    = var.artifacts_dir
    runtime          = var.runtime
    function_name    = var.function_name
    source_path      = var.source_path
    hash_extra       = var.hash_extra
    hash_extra_paths = jsonencode(["${path.module}/lambda.py"])
  }
}

# Build the zip archive whenever the filename changes.
resource "null_resource" "archive" {
  count = var.create && var.create_package ? 1 : 0

  triggers = {
    filename  = data.external.archive_prepare[0].result.filename
    timestamp = data.external.archive_prepare[0].result.timestamp
  }

  provisioner "local-exec" {
    interpreter = ["python", "${path.module}/lambda.py", "build"]
    command     = data.external.archive_prepare[0].result.build_data
    working_dir = path.cwd
  }
}
