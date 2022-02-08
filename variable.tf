variable "aws_region" {
  type        = string
  description = "VPC Region"
  default     = "us-east-1"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}

# variable "git_access_token" {
#   type        = string
#   description = "Github access token"
# }

# variable "github_repos" {
#   type = list(string)
# }

# variable "user" {
#   type = list(string)
# }

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "172.168.0.0/16"
}

variable "public_subnet_block" {
  description = "Public Subnet 1 CIDR"
  default     = "172.168.0.0/24"
}

variable "private_subnet_block" {
  description = "Private Subnet 1 CIDR"
  default     = "172.168.1.0/24"
}


variable "public_subnet_az" {
  description = "Public Subnet 1 Availability Zone"
  default     = "us-east-1a"
}

variable "key_name" {
  type = string
}

variable "private_subnet_az" {
  description = "Private Subnet 2 Availability Zone"
  default     = "us-east-1b"
}

variable "engine" {
  description = "RDS Engine"
  default     = "mysql"
}

variable "db_name" {
  description = "Database Name"
  default     = "blog"
}

variable "db_username" {
  description = "Database Username"
}

variable "db_password" {
  description = "Database Password"
}
