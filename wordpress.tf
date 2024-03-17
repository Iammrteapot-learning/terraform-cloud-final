resource "aws_instance" "wordpress" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone

  tags = {
    Name = "terraform_wordpress"
  }
}

resource "aws_network_interface_attachment" "wordpress_public_attachment" {
  instance_id          = aws_instance.wordpress.id
  network_interface_id = aws_network_interface.wordpress_to_public_network_interface.id
  device_index         = 0
}

resource "aws_network_interface_attachment" "wordpress_internal" {
  instance_id          = aws_instance.wordpress.id
  network_interface_id = aws_network_interface.wordpress_to_mariadb_network_interface.id
  device_index         = 1
}