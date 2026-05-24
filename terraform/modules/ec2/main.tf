resource "aws_instance" "bastion" {

  ami = "ami-09ed39e30153c3bf9"

  instance_type = "t3.micro"

  subnet_id = element(var.public_subnet_ids_list, 0)
  key_name  = "aws"

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-bastion"
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.environment}-bastion-sg"
  description = "Bastion Host Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my IP"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-bastion-sg"
  }
}
