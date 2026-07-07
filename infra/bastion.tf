# 2. Generate a secure Private/Public key pair in-memory
resource "tls_private_key" "ec2_key" {
  algorithm = "ED25519"
}

# 3. Create the AWS Key Pair using the generated OpenSSH public key string
resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# 4. Output the Private Key string to your terminal
output "private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true # Hides the raw key text from printing automatically during apply
}
resource "aws_instance" "bastion" {

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  key_name               = aws_key_pair.bastion.key_name

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }

}