resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform_vpc"
  }

}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform_igw"
  }
}

resource "aws_subnet" "wordpress_public_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "terraform_wordpress_public_subnet"
  }
}

resource "aws_subnet" "wordpress_private_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "terraform_wordpress_to_mariadb_subnet"
  }
}


resource "aws_subnet" "mariadb_private_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "terraform_mariadb_to_nat_subnet"
  }
}

resource "aws_subnet" "mariadb_public_subnet" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "terraform_mariadb_nat_subnet"
  }
}

resource "aws_route_table" "wordpress_public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }
}

resource "aws_route_table_association" "wordpress_public_route_association" {
  subnet_id      = aws_subnet.wordpress_public_subnet.id
  route_table_id = aws_route_table.wordpress_public_route_table.id
}

resource "aws_eip" "mariadb_nat" {
  tags = {
    Name = "mariadb_nat_eip"
  }
}

resource "aws_nat_gateway" "mariadb_nat_gateway" {
  allocation_id = aws_eip.mariadb_nat.id
  subnet_id     = aws_subnet.mariadb_public_subnet.id
  tags = {
    Name = "mariadb_nat"
  }
}

resource "aws_route_table" "mariadb_private_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mariadb_nat_gateway.id
  }
}

resource "aws_route_table_association" "mariadb_private_route_association" {
  subnet_id      = aws_subnet.mariadb_private_subnet.id
  route_table_id = aws_route_table.mariadb_private_route_table.id
}

resource "aws_route_table" "internal_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "internal_route_table"
  } 
}

resource "aws_route_table_association" "internal_route_association" {
  subnet_id      = aws_subnet.wordpress_private_subnet.id
  route_table_id = aws_route_table.internal_route_table.id
}