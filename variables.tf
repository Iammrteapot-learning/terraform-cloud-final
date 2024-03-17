variable "region" {
  description = "The AWS region to launch the instance."
  type        = string
}

variable "availability_zone" {
  description = "The AWS availability zone to launch the instance."
  type        = string
}

variable "ami" {
  description = "The AMI to use for the instance."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
}

variable "database_name" {
  description = "The name of the database to create."
  type        = string
}

variable "database_user" {
  description = "The username for the database."
  type        = string
}

variable "database_pass" {
  description = "The password for the database."
  type        = string
}

variable "admin_user" {
  description = "The username for the WordPress admin."
  type        = string
}

variable "admin_pass" {
  description = "The password for the WordPress admin."
  type        = string
}
