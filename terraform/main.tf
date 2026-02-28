data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = { Name = "bastion" }
}

# App Server
resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = { Name = "app" }
}

resource "local_file" "inventory" {
  filename = "${path.module}/inventory.ini"
  content  = <<EOT
[bastion]
${aws_instance.bastion.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem

[app]
${aws_instance.app.private_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.bastion.public_ip}"'
EOT
}