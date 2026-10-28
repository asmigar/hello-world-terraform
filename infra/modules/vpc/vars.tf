variable "env" {
  type        = string
  description = "name of the env i.e. dev/prod/uat/test"
}

variable "vpc_cidr_block" {
  type = string
  description = "cidr block to create vpc with"
}