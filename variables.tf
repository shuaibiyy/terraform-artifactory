variable "access_key" {
  description = "The AWS access key."
}

variable "secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-west-2"
}

variable "s3_bucket" {
  description = "S3 bucket to store terraform remote state and artifactory data."
  default = "mycompany-artifactory"
}

variable "key_name" {
  description = "Name of key pair. Must exist in chosen region."
  default = "artifactory"
}

variable "instance_type" {
  default = "t2.small"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the Ubuntu 14.04 LTS."
  default = {
    us-east-1 = "ami-fce3c696"
    us-west-1 = "ami-06116566"
    us-west-2 = "ami-9abea4fb"
    eu-west-1 = "ami-f95ef58a"
  }
}
