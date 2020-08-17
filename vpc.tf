#
# VPC Resources:
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "vpc-terraform" {
  cidr_block = var.aws_vpc_cidr[terraform.workspace]

  tags = map(
    "Name", "vpc-${terraform.workspace}",
    "envinronment", "${terraform.workspace}",
  )
}

resource "aws_subnet" "subnet-public" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "${var.aws_vpc_cidr_halfoctet[terraform.workspace]}.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc-terraform.id

  tags = map(
    "Name", "subnet-public-${terraform.workspace}",
    "envinronment", "${terraform.workspace}",
  )
}

resource "aws_internet_gateway" "igw-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id

  tags = map(
    "Name", "igw-terraform-${terraform.workspace}",
    "envinronment", "${terraform.workspace}",
  )
}

resource "aws_route_table" "rt-terraform" {
  vpc_id = aws_vpc.vpc-terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-terraform.id
  }
}

resource "aws_route_table_association" "rta-terraform" {
  count          = 2
  subnet_id      = aws_subnet.subnet-public[count.index].id
  route_table_id = aws_route_table.rt-terraform.id
}
