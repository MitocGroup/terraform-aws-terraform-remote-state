output "outputs" {
  description = "Replicate similar behavior as data.terraform_remote_state.[example].outputs"

  value = length(data.terraform_remote_state.current.*.outputs) > 0 ? {
    for i in keys(var.outputs):
    i => lookup(element(data.terraform_remote_state.current.*.outputs, 0), i, "")
  } : {
    for i in keys(var.outputs):
    i => jsondecode(var.types[var.outputs[i]]).value
  }
}
