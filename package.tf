locals {
  python = (substr(pathexpand("~"), 0, 1) == "/") ? "python3" : "python.exe"
}

# Generates a filename for the zip archive based on the content of the files
# in source_path. The filename will change when the source code changes.
data "external" "archive_prepare" {
  count = var.create && var.create_package ? 1 : 0

  program = [local.python, "${path.module}/package.py", "prepare"]

  query = {
    paths = jsonencode({
      module = path.module
      root   = path.root
      cwd    = path.cwd
    })

    docker = var.build_in_docker ? jsonencode({
      docker_pip_cache          = var.docker_pip_cache
      docker_build_root         = var.docker_build_root
      docker_file               = var.docker_file
      docker_image              = var.docker_image
      with_ssh_agent            = var.docker_with_ssh_agent
      docker_additional_options = var.docker_additional_options
      docker_entrypoint         = var.docker_entrypoint
    }) : null

    artifacts_dir = var.artifacts_dir
    runtime       = var.runtime
    source_path   = jsonencode(var.source_path)
    hash_extra    = var.hash_extra
    hash_extra_paths = jsonencode(
      [
        # Temporary fix when building from multiple locations
        # We should take into account content of package.py when counting hash
        # Related issue: https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/63
        # "${path.module}/package.py"
      ]
    )

    recreate_missing_package = var.recreate_missing_package
  }
}

# This transitive resource used as a bridge between a state stored
# in a Terraform plan and a call of a build command on the apply stage
# to transfer a noticeable amount of data
resource "local_file" "archive_plan" {
  count = var.create && var.create_package ? 1 : 0

  content              = var.build_in_docker ? sensitive(data.external.archive_prepare[0].result.build_plan) : data.external.archive_prepare[0].result.build_plan
  filename             = data.external.archive_prepare[0].result.build_plan_filename
  directory_permission = "0755"
  file_permission      = "0644"
}

# Build the zip archive whenever the filename changes.
resource "null_resource" "archive" {
  count = var.create && var.create_package ? 1 : 0

  triggers = {
    filename  = data.external.archive_prepare[0].result.filename
    timestamp = var.trigger_on_package_timestamp ? data.external.archive_prepare[0].result.timestamp : null
  }

  provisioner "local-exec" {
    interpreter = [
      local.python, "${path.module}/package.py", "build",
      "--timestamp", data.external.archive_prepare[0].result.timestamp
    ]
    command = data.external.archive_prepare[0].result.build_plan_filename
    quiet   = var.quiet_archive_local_exec
  }

  depends_on = [local_file.archive_plan]
}
