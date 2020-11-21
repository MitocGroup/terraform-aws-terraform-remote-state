data "terraform_remote_state" "current" {
  count      = var.count
  backend    = var.backend
  config     = var.config
  depends_on = [data.external.current]
}

data "external" "current" {
  count   = var.count * (local.current_tfstate == var.config["key"] ? 0 : 1)
  program = ["/bin/sh", "${abspath(path.module)}/tfstate.sh", var.config["bucket"], var.config["key"], jsonencode(data.template_file.current.rendered)]
}

data "aws_s3_bucket_objects" "current" {
  bucket   = var.config["bucket"]
  prefix   = replace(var.config["key"], var.default_tfstate, "")
  max_keys = var.max_keys
}

data "template_file" "current" {
  template = file("${abspath(path.module)}/tfstate.json.tpl")
  vars = {
    outputs = join(",", local.current_outputs)
  }
}
