resource "aws_key_pair" "public" {
  key_name   = "public_key"
  public_key = file(".ssh/public_key.pub")
}