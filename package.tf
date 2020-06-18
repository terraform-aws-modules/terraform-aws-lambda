locals {
  python = (substr(pathexpand("~"), 0, 1) == "/") ? "python3" : "python.exe"
}

# Generates a filename for the zip archive based on the content of the files
# in source_path. The filename will change when the source code changes.
data "external" "archive_prepare" {
  count = var.create && var.create_package ? 1 : 0

  program     = [local.python, "${path.module}/package.py", "prepare"]
  working_dir = path.cwd

  query = {
    paths = jsonencode({
      module = path.module
      root   = path.root
      cwd    = path.cwd
    })

    docker = var.build_in_docker ? jsonencode({
      docker_pip_cache  = var.docker_pip_cache
      docker_build_root = var.docker_build_root
      docker_file       = var.docker_file
      docker_image      = var.docker_image
      with_ssh_agent    = var.docker_with_ssh_agent
    }) : null

    artifacts_dir    = var.artifacts_dir
    runtime          = var.runtime
    source_path      = jsonencode(var.source_path)
    hash_extra       = var.hash_extra
    hash_extra_paths = jsonencode(["${path.module}/package.py"])
  }
}

# This transitive resource used as a bridge between a state stored
# in a Terraform plan and a call of a build command on the apply stage
# to transfer a noticeable amount of data
resource "local_file" "archive_plan" {
  count = var.create && var.create_package ? 1 : 0

  content              = data.external.archive_prepare[0].result.build_plan
  filename             = data.external.archive_prepare[0].result.build_plan_filename
  directory_permission = "0755"
  file_permission      = "0644"
}

# Build the zip archive whenever the filename changes.
resource "null_resource" "archive" {
  count = var.create && var.create_package ? 1 : 0

  triggers = {
    filename  = data.external.archive_prepare[0].result.filename
    timestamp = data.external.archive_prepare[0].result.timestamp
  }

  provisioner "local-exec" {
    interpreter = [
      local.python, "${path.module}/package.py", "build",
      "--timestamp", data.external.archive_prepare[0].result.timestamp
    ]
    command     = data.external.archive_prepare[0].result.build_plan_filename
    working_dir = path.cwd
  }

  depends_on = [local_file.archive_plan]
}
