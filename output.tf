output "outputs" {
  value = {
    for i in keys(var.outputs):
    i => lookup(element(data.terraform_remote_state.current.*.outputs, 0), i, "")
  }
}
