
# Create an IAM Role for EC2 Instance with SSM Access

resource "aws_iam_role" "ec2_ssm_access_role" {
  name = "ec2_ssm_access_role"

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
  tags = {
    Name = "EC2 SSM Role"
  }

}

# Attach the SSM managed policy to the IAM role

resource "aws_iam_role_policy_attachment" "ec2_ssm_acees_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_ssm_access_role.name

}

# Create an IAM instance profile and associate it with the IAM role

resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "ec2-ssm-instance-profile"

  role = aws_iam_role.ec2_ssm_access_role.name

}

# Create an EC2 instance and attach the IAM role to it


resource "aws_instance" "app_server" {
  ami           = "ami-08f0bc76ca5236b20"
  instance_type = "t2.micro"
  # Attch the IAM Role
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_instance_profile.name

  tags = {
    Name = "ExampleAppServerInstance"
  }

}


