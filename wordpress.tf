resource "aws_instance" "wordpress" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone

  depends_on = [aws_instance.mariadb]

  network_interface {
    network_interface_id = aws_network_interface.wordpress_to_public_network_interface.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.wordpress_to_mariadb_network_interface.id
    device_index         = 1
  }

  key_name = aws_key_pair.public.key_name
  tags = {
    Name = "terraform_wordpress"
  }
}

resource "aws_eip" "wordpress" {
  network_interface = aws_network_interface.wordpress_to_public_network_interface.id
}
