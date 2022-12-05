variable "ami" {
  type        = string
  default     = "ami-0b0dcb5067f052a63"
  description = "The Linux AMI"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "We have a t2 micro instance type!"
}

variable "key_name" {
  default     = "lukey"
  description = "The key pair"
}

variable "monitoring" {
  default = true
}

variable "vpc_security_group_ids" {
  default     = ["sg-0a967d94600bc0405"]
  description = "The security group id"
}