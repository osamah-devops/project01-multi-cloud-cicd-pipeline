#############################################
# Launch Template
#############################################
# 2. Generate a secure Private/Public key pair in-memory
resource "tls_private_key" "ec2_key" {
  algorithm = "ED25519"
}

# 3. Create the AWS Key Pair using the generated OpenSSH public key string
resource "aws_key_pair" "instance_key" {
  key_name   = "instance-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_launch_template" "web" {

  name_prefix   = "web-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.instance_key.key_name

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2.arn
  }

  user_data = base64encode(file("user_data.sh"))

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "WebServer"
    }
  }

  tags = {
    Name = "WebLaunchTemplate"
  }
}

#############################################
# Auto Scaling Group
#############################################

resource "aws_autoscaling_group" "web" {

  name = "web-asg"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = aws_subnet.private[*].id

  target_group_arns = [
    aws_lb_target_group.main.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "WebServer"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
output "instance_private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true # Hides the raw key text from printing automatically during apply
}