resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("ec2-key.pub")
}
resource "aws_instance" "bastion" {

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  key_name               = aws_key_pair.bastion_key.key_name

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }

}