variable "aws_region" {
  type = string
}

variable "vpc" {
  type = string
}

variable "public_subnet" {
  type = list(string)
}

variable "private_subnet" {
  type = list(string)
}
