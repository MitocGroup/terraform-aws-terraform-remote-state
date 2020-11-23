variable "config" {
  type        = map(string)
  description = "This variable is used to define the config values for s3 powered `data.terraform_remote_state`"
}

variable "outputs" {
  type        = map(string)
  description = "This variable is used to define the outputs' expected keys and corresponding types"
}

variable "counting" {
  type        = number
  description = "This variable is used to define count; since `count` is reserved keyword, please use `counting` as part of this module"

  default = 1
}

variable "types" {
  type        = map(string)
  description = "This variable is used to define the outputs' expected json structure"

  default = {
    "string"       = "{\"value\":\"\",\"type\":\"string\"}"
    "list(string)" = "{\"value\":[\"\"],\"type\":[\"list\",\"string\"]}"
    "map(string)"  = "{\"value\":{\"\"},\"type\":[\"map\",\"string\"]}"
  }
}

variable "default_tfstate" {
  type        = string
  description = "This variable is used to default tfstate filename (e.g. `terraform.tfstate`)"

  default = "terraform.tfstate"
}
