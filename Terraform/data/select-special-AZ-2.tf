data "aws_ec2_instance_type_offerings" "my_instance_type" {
  for_each = toset(["us-east-1a", "us-east-1b", "us-east-1e"])
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

output "output_v1_1" {
  value = [for k in data.aws_ec2_instance_type_offerings.my_instance_type : k.instance_types]
}

output "output_v2_1" {
  value = {
    for az,detail in data.aws_ec2_instance_type_offerings.my_instance_type :
    az => detail.instance_types
  }
}
--------------------------------------------------------------------------------
Changes to Outputs:
  + output_v1_1 = [
      + [
          + "t3.micro",
        ],
      + [
          + "t3.micro",
        ],
      + [],
    ]
  + output_v2_1 = {
      + us-east-1a = [
          + "t3.micro",
        ]
      + us-east-1b = [
          + "t3.micro",
        ]
      + us-east-1e = []  #------------------> t3.micro not exist in this AZ
    }
