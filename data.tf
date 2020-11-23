data "terraform_remote_state" "current" {
  count      = var.counting
  backend    = "s3"
  config     = var.config
  depends_on = [data.external.current]
}

data "external" "current" {
  count   = var.counting * (local.current_tfstate == var.config["key"] ? 0 : 1)
  program = ["/bin/sh", "${abspath(path.module)}/tfstate.sh", jsonencode(data.template_file.current.rendered), var.config["bucket"], var.config["key"], contains(var.config, "region") ? var.config["region"] : "us-east-1", contains(var.config, "role_arn") ? var.config["role_arn"] : ""]
}

data "aws_s3_bucket_objects" "current" {
  max_keys = 1
  bucket   = var.config["bucket"]
  prefix   = replace(var.config["key"], var.default_tfstate, "")
}

data "template_file" "current" {
  template = file("${abspath(path.module)}/tfstate.json.tpl")
  vars = {
    outputs = join(",", local.current_outputs)
  }
}
