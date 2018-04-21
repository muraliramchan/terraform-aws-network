variable "region" { description = "AWS region" }

variable "vpc_cidr" { description = "VPC CIDR range" }

variable "azs" {
  type = "list"
  description = "The availability zones eg. [\"a\",\"b\"]"
}

