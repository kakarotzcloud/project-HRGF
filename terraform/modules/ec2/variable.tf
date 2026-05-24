variable "environment" {
  type = string
}

variable "public_subnet_ids_list" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
