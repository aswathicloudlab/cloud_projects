
# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}


# Create route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Associate subnet with route table
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create IAM role for EC2 instance with SSM access
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2_ssm_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "EC2 SSM Role"
  }
}

# Attach the SSM managed policy to the IAM role

resource "aws_iam_role_policy_attachment" "ec2_ssm_acees_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_ssm_role.name

}

# Create an IAM instance profile and associate it with the IAM role

resource "aws_iam_instance_profile" "webserver_instance_profile" {
  name = "webserver_instance_profile_v2"

  role = aws_iam_role.ec2_ssm_role.name

}

# Launch EC2 instance running web server
resource "aws_instance" "web_server" {
  ami           = "ami-0d9f286195031c3d9" # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  # associate public IP address with the instance
  associate_public_ip_address = true
  
  # key_name      = tls_private_key.my_key_pair.private_key_pem
  user_data     = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "Hello, World!" > /var/www/html/index.html
              systemctl start httpd
              EOF
  tags = {
    Name = "web-server"
  }
  iam_instance_profile = aws_iam_instance_profile.webserver_instance_profile.name
}

# Create security group for web server allowing HTTP traffic
resource "aws_security_group" "web_server_sg" {
  name_prefix = "web-server-sg"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-server-sg"
  }
}

# Add security group to the web server instance
resource "aws_network_interface_sg_attachment" "web_server_sg_attachment" {
  security_group_id    = aws_security_group.web_server_sg.id
  network_interface_id = aws_instance.web_server.primary_network_interface_id
}