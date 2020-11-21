# Terraform Module `terraform-remote-state`
The `terraform-remote-state` terraform module is designed to avoid errors
associated with missing `terraform.tfstate` file in S3 remote backend.

No more `Unable to find remote state`! Enough is enough.

## Before
```tf
data "terraform_remote_state" "example" {
  count   = var.is_sandbox ? 1 : 0  ## optional
  backend = "s3"
  config  = {
    bucket   = "[YOUR_S3_BUCKET_HERE]"
    key      = "[YOUR_S3_PATH_TO_TFSTATE_HERE]"
    region   = "[YOUR_AWS_REGION_HERE]"   ## optional
    role_arn = "[YOUR_ASSUME_ROLE_HERE]"  ## optional
  }
}
```

When running `terraform plan`, very often we get the following error:
```sh
data.terraform_remote_state.vpc[0]: Refreshing state...
data.terraform_remote_state.tgw[0]: Refreshing state...

Error: Unable to find remote state

  on data.tf line 7, in data "terraform_remote_state" "vpc":
   7: data "terraform_remote_state" "vpc" {

No stored state was found for the given workspace in the given backend.
```

## After
```tf
module "example" {
  source  = "MitocGroup/terraform-remote-state/aws"
  version = "0.0.1"
  count   = var.is_sandbox ? 1 : 0  ## optional
  config  = {
    bucket   = "[YOUR_S3_BUCKET_HERE]"
    key      = "[YOUR_S3_PATH_TO_TFSTATE_HERE]"
    region   = "[YOUR_AWS_REGION_HERE]"   ## optional
    role_arn = "[YOUR_ASSUME_ROLE_HERE]"  ## optional
  }
  outputs = {
    string_example = "string"
    list_example   = "list(string)"
    map_example    = "map(string)"
  }
}
```

When running `terraform plan`, we get the following response instead:
```sh
  # module.example.data.terraform_remote_state.current[0] will be read during apply
  # (config refers to values not yet known)
 <= data "terraform_remote_state" "vpc"  {
      + backend = "s3"
      + config  = {
          + "bucket" = "[REDACTED]"
          + "key"    = "[REDACTED]"
          + "region" = "[REDACTED]"
        }
      + outputs = {
          + string_example = "[REDACTED]"
          + list_example   = ["[REDACTED]"]
          + map_example    = {"[REDACTED]": "[REDACTED]"}
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

```
