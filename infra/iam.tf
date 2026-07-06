#################################
# IAM Role for EC2 SSM
#################################

resource "aws_iam_role" "ec2_ssm" {

  name = "EC2SSMRole"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

#################################
# Attach AmazonSSMManagedInstanceCore
#################################

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_ssm.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

#################################
# Instance Profile
#################################

resource "aws_iam_instance_profile" "ec2" {

  name = "EC2SSMProfile"

  role = aws_iam_role.ec2_ssm.name

}