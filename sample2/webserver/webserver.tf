

#----------------------------------------------------------
# ACS730 - Mid Term Exam
#
#
#----------------------------------------------------------

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use remote state to retrieve the data
data "terraform_remote_state" "remote_config" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "mocks3114518228"           // Bucket from where to GET Terraform State
    key    = "network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                 // Region where bucket created
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "my_amazon" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.remote_config.outputs.subnet_id_2
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/install_httpd.sh")

  lifecycle {
    create_before_destroy = true
  }
}


# Attach EBS volume
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_ebs.id
  instance_id = aws_instance.my_amazon.id
}



# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = "midterm.pub"
  public_key = file("midterm.pub")
}

# Create another EBS volume
resource "aws_ebs_volume" "web_ebs" {
  availability_zone = data.aws_availability_zones.available.names[1]
  size              = 40
}

