# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Create a route table and a public route to the internet trough the internet gateway
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# Retrieve the availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a public subnet in the first availability zone
resource "aws_subnet" "public" {
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 0)
  vpc_id            = aws_vpc.main.id
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

