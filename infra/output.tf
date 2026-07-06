output "alb_dns_name" {

  value = aws_lb.main.dns_name

}

output "alb_arn" {

  value = aws_lb.main.arn

}

output "vpc_id" {

  value = aws_vpc.main.id

}

output "public_subnets" {

  value = aws_subnet.public[*].id

}

output "private_subnets" {

  value = aws_subnet.private[*].id

}

output "bastion_public_ip" {

  value = aws_instance.bastion.public_ip

}

output "autoscaling_group_name" {

  value = aws_autoscaling_group.web.name

}