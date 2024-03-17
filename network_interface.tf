resource "aws_network_interface" "mariadb_to_nat_network_interface" {
  subnet_id       = aws_subnet.mariadb_private_subnet.id
  security_groups = [aws_security_group.gateway_sg.id]

  tags = {
    Name = "mariadb_to_nat_network_interface"
  }
}

resource "aws_network_interface" "maria_to_wordpress_network_interface" {
  subnet_id       = aws_subnet.wordpress_private_subnet.id
  security_groups = [aws_security_group.mariadb_sg.id]

  tags = {
    Name = "maria_to_wordpress_network_interface"
  }
}

resource "aws_network_interface" "wordpress_to_mariadb_network_interface" {
  subnet_id       = aws_subnet.wordpress_private_subnet.id
  security_groups = [aws_security_group.wordpress_sg.id]
  tags = {
    Name = "wordpress_to_mariadb_network_interface"
  }
}

resource "aws_network_interface" "wordpress_to_public_network_interface" {
  subnet_id       = aws_subnet.wordpress_public_subnet.id
  security_groups = [aws_security_group.gateway_sg.id]

  tags = {
    Name = "wordpress_to_public_network_interface"
  }

}
