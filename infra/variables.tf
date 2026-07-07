variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 Key Pair"
}

variable "certificate_arn" {
  description = "ACM Certificate ARN"
  default     = "arn:aws:acm:us-east-1:072754096540:certificate/4b5e7d68-8d5e-49e2-a57f-0a1045800819"
  sensitive   = true
}

variable "desired_capacity" {
  default = 2
}

variable "max_size" {
  default = 3
}

variable "min_size" {
  default = 1
}