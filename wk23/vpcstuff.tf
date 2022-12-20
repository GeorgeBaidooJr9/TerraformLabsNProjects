resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "week-23-gateway" #internet gateway setup for the vpc
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1" #the first public subnet
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2" #the second public subnet
  }
}

resource "aws_route_table" "week-23-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "week-23-route-table" #route table setup
  }
}


resource "aws_route_table_association" "wk23-public-route-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.week-23-route-table.id
}

resource "aws_route_table_association" "wk23-public-route-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.week-23-route-table.id
}