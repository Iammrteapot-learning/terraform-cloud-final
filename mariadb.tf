resource "aws_instance" "mariadb" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone
  network_interface {
    network_interface_id = aws_network_interface.mariadb_to_nat_network_interface.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.maria_to_wordpress_network_interface.id
    device_index         = 1
  }

  user_data = templatefile("mariadb_init.tftpl", {
    database_name = var.database_name,
    database_user = var.database_user,
    database_pass = var.database_pass

  })
  tags = {
    Name = "terraform_mariadb"
  }
}

