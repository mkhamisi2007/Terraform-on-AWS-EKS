data "aws_availability_zones" "my_az" { #-----------------------> it give a list of our AZ
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ec2_instance_type_offerings" "my_instance_type" {
  for_each = toset(data.aws_availability_zones.my_az.names) #-------> use the list of our AZ
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }
  filter {
    name   = "location"
    values = [each.key]
  }
  location_type = "availability-zone"
}

output "output_v3_1" {
  value = {
    for az, detail in data.aws_ec2_instance_type_offerings.my_instance_type :
    az => detail.instance_types
  }
}
------------------------------------------------------------------------------------
Changes to Outputs:
  + output_v3_1 = {
      + us-east-1a = [
          + "t3.micro",
        ]
      + us-east-1b = [
          + "t3.micro",
        ]
      + us-east-1c = [
          + "t3.micro",
        ]
      + us-east-1d = [
          + "t3.micro",
        ]
      + us-east-1e = []
      + us-east-1f = [
          + "t3.micro",
        ]
    }
