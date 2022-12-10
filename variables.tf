# ---./main.tf

variable "public_sg" {}
variable "public_subnet" {}
variable "private_sg" {}
variable "private_subnet" {}
variable "key_name" {
    default = "lukey"
    description = "The key pair"
}
variable "elb" {}
variable "alb_tg" {}

variable "bastion_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "database_instance_type" {
  type    = string
  default = "t3.micro"
}