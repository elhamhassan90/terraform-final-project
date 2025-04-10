# Create Key Pair from existing public key file
resource "aws_key_pair" "elham_key" {
  key_name   = "elham-ec2-key"
  public_key = file("/home/elham/Desktop/terraform-final-project/terraform-pro/modules/ec2/elham-ec2-key.pub")
}

# Launch two EC2 instances in public subnets
resource "aws_instance" "public" {
  count         = 2
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_ids[count.index]
  key_name      = aws_key_pair.elham_key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]

  provisioner "remote-exec" {
    inline = [
  "echo Enabling nginx extras",
  "sudo amazon-linux-extras enable nginx1",
  "echo Cleaning yum metadata",
  "sudo yum clean metadata",
  "echo Installing nginx",
  "sudo yum install -y nginx",
  "echo Enabling nginx",
  "sudo systemctl enable nginx",
  "echo Starting nginx",
  "sudo systemctl start nginx"
]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/elham/Desktop/terraform-final-project/terraform-pro/modules/ec2/elham-ec2-key")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "elham-public-${count.index + 1}"
  }
}

# Launch two EC2 instances in private subnets
resource "aws_instance" "private" {
  count         = 2
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_ids[count.index]
  key_name      = aws_key_pair.elham_key.key_name
  vpc_security_group_ids = [var.security_group_id]

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo yum install -y httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
    ]

    connection {
      type          = "ssh"
      user          = "ec2-user"
      private_key   = file("/home/elham/Desktop/terraform-final-project/terraform-pro/modules/ec2/elham-ec2-key")
      host          = self.private_ip
      bastion_host        = var.bastion_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file("/home/elham/Desktop/terraform-final-project/terraform-pro/modules/ec2/elham-ec2-key")
    }
  }

  tags = {
    Name = "elham-private-${count.index + 1}"
  }
}

# Data source to get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

