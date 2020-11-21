variable "counting" {
  type = number
}

variable "config" {
  type = map(string)
}

variable "outputs" {
  type = map(string)
}

variable "types" {
  type    = map(string)
  default = {
    "string"       = "{\"value\":\"\",\"type\":\"string\"}"
    "list(string)" = "{\"value\":[\"\"],\"type\":[\"list\",\"string\"]}"
    "map(string)"  = "{\"value\":{\"\"},\"type\":[\"map\",\"string\"]}"
  }
}

variable "backend" {
  type    = string
  default = "s3"
}

variable "max_keys" {
  type    = number
  default = 1
}

variable "default_tfstate" {
  type    = string
  default = "terraform.tfstate"
}

variable "failover_tfstate" {
  type    = string
  default = "terraform/terraform.empty.tfstate"
}
