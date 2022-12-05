#Creates AWS Linux EC2 Instance using the Linux AMI
resource "aws_instance" "app_server" {
  ami                    = "ami-0b0dcb5067f052a63"
  instance_type          = "t2.micro"
  key_name               = "lukey"
  monitoring             = true
  vpc_security_group_ids = ["sg-0a967d94600bc0405"]

  tags = {
    Name = "Week21Terraform-1"
  }
}
