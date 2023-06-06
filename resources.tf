#Create a new VPC in AWS
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "TerraformVPC2023"
  }
}


#AWS Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}


