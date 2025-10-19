# To create a VPC in AWS with Terraform what is requied. Write the components first.

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    # variable interpolation 
    Name     = "${var.environment}-vpc" #dev-vpc, prod-vpc
    Projects = var.project
  }
}

# Private Subnet - 1
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[0]
  availability_zone = "${data.aws_region.current.name}a"


  tags = {
    Name = "${var.environment}-private-sub-1"
  }
}

# Private Subnet - 2
resource "aws_subnet" "private_2" { #The second name in the resource line must be unique
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[1]
  availability_zone = "${data.aws_region.current.name}b"


  tags = {
    Name = "${var.environment}-private-sub-2"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-private-rt"
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
  cidr_block              = var.subnet_cidrs[2]
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-sub-1"
  }
}

# Public Subnet - 2
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[3]
  availability_zone = "${data.aws_region.current.name}b"

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-sub-2"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-public-rt"
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
    Name = "${var.environment}-IGW"
  }
}

#NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  #allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_1.id

  tags = {
    Name = "${var.environment}-nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.

  #Explicit dependecy
  depends_on = [aws_internet_gateway.igw, aws_route_table.public]
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${var.environment}-nat-eip"
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
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[4]
  availability_zone = "${data.aws_region.current.name}a"


  tags = {
    Name = "${var.environment}-rds-sub-1"
  }
}

resource "aws_subnet" "rds_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[5]
  availability_zone = "${data.aws_region.current.name}b"


  tags = {
    Name = "${var.environment}-rds-sub-2"
  }
}