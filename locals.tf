locals {
  current_tfstate = length(data.aws_s3_bucket_objects.current.keys) > 0 ? element(data.aws_s3_bucket_objects.current.keys, 0) : ""
  current_outputs = [
    for i in keys(var.outputs):
    format("\"%s\":%s", i, var.types[var.outputs[i]])
  ]
}
