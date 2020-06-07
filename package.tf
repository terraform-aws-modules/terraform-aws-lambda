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
      docker_pip_cache = var.docker_pip_cache
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

# This transitive resource used as a bridge between a state stored
# in a Terraform plan and a call of a build command on the apply stage
# to transfer a noticeable amount of data
resource "local_file" "archive_plan" {
  count = var.create && var.create_package ? 1 : 0

  # Using a sensitive_content to omit showing diffs
//  content = data.external.archive_prepare[0].result.build_plan
//  content_base64 = data.external.archive_prepare[0].result.build_plan_base64
  content_base64 = base64encode(data.external.archive_prepare[0].result.build_plan)
  filename = "${data.external.archive_prepare[0].result.filename}.plan"
  file_permission = "0664"
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
    command     = "${data.external.archive_prepare[0].result.filename}.plan"
    working_dir = path.cwd
  }

  depends_on = [local_file.archive_plan]
}
