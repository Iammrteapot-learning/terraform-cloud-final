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

  user_data = templatefile("wordpress_init.tftpl", {
    database_host = aws_network_interface.maria_to_wordpress_network_interface.private_ip,
    database_name = var.database_name,
    database_user = var.database_user,
    database_pass = var.database_pass
    admin_user = var.admin_user
    admin_pass = var.admin_pass
    wordpress_url = aws_eip.wordpress.public_ip
    s3_access_key = aws_iam_access_key.wordpress_access_key.id  
    s3_secret_key = aws_iam_access_key.wordpress_access_key.secret
    s3_bucket = aws_s3_bucket.wordpress_s3.bucket
    region = var.region
  })

  tags = {
    Name = "terraform_wordpress"
  }
}

resource "aws_eip" "wordpress" {
  network_interface = aws_network_interface.wordpress_to_public_network_interface.id
}
