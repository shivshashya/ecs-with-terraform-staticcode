# To create a VPC in AWS with Terraform what is requied. Write the components first.

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "august-bootcamp-vpc-terraform"
  }
}

# Private Subnet - 1
resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"


  tags = {
    Name = "private-subnet-1"
  }
}

# Private Subnet - 2
resource "aws_subnet" "private_2" { #The second name in the resource line must be unique
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1b"


  tags = {
    Name = "private-subnet-2"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

# Route Table Association with Private Subnets
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}


# Route for private subnets to Internet via NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# Public Subnet - 1
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

# Public Subnet - 2
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-route-table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route Table Association with Public Subnets
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

#NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = data.aws_eip.by_allocation_id.id
  #allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.

  #Explicit dependecy
  depends_on = [aws_internet_gateway.igw, aws_route_table.public]
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-gateway-eip"
  }
}





# Private route table
# Route table association with private subnet
# nat gateway in public subnet
# elastic ip for nat gateway

# public subnet -2 
# public route table
# route table association with public subnet
# route for public subnet -> internet gateway



#2-Subnet groups for RDS
resource "aws_subnet" "rds_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-south-1a"


  tags = {
    Name = "rds-subnet-1"
  }
}

resource "aws_subnet" "rds_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "ap-south-1b"


  tags = {
    Name = "rds-subnet-2"
  }
}