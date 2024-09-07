# Build the zip archive whenever the filename changes.
# locals {
#   java21_working_dir   = "${path.module}/runtimes/java21"
#   java21_build_command = "gradle build -i"

#   source_path   = local.java21_working_dir
#   path_include  = ["**"]
#   path_exclude  = ["**/.gradle/**", "**/build/**"]
#   files_include = setunion([for f in local.path_include : fileset(local.source_path, f)]...)
#   files_exclude = setunion([for f in local.path_exclude : fileset(local.source_path, f)]...)
#   files         = sort(setsubtract(local.files_include, local.files_exclude))

#   dir_sha = sha1(join("", [for f in local.files : filesha1("${local.source_path}/${f}")]))
# }

# resource "null_resource" "java21_build" {
#   triggers = {
#     # todo: Add tracking for content changes
#     dir_sha = local.dir_sha
#     command = local.java21_build_command
#   }

#   provisioner "local-exec" {
#     working_dir = local.java21_working_dir
#     command     = local.java21_build_command
#   }
# }

# create_package         = false
# local_existing_package = "${local.java21_working_dir}/build/distributions/java21.zip"
# depends_on = [null_resource.java21_build]
