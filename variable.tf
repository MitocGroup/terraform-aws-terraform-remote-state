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

variable "default_tfstate" {
  type    = string
  default = "terraform.tfstate"
}
