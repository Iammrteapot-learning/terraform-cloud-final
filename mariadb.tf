resource "aws_instance" "mariadb" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone

  tags = {
    Name = "terraform_mariadb"
  }
}

resource "aws_network_interface_attachment" "mariadb_attachment" {
  instance_id          = aws_instance.mariadb.id
  network_interface_id = aws_network_interface.mariadb_to_nat_network_interface.id
  device_index         = 0
}

resource "aws_network_interface_attachment" "mariadb_internal" {
  instance_id          = aws_instance.mariadb.id
  network_interface_id = aws_network_interface.maria_to_wordpress_network_interface.id
  device_index         = 1
}

# resource "aws_security_group" "mariadb_sg" {
#     name_prefix = "terraform_mariadb_"
#     vpc_id = aws_vpc.terraform_vpc.id

#     ingress {
#         from_port = 3306
#         to_port = 3306
#         protocol = "tcp"
#         cidr_blocks = []
#     }
# }