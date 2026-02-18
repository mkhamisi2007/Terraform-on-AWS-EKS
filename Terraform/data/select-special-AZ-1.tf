# This code is for give a list of AZ that support "t3.micro" EC2 type in all AZs
-----------------------------------------------------------------------------------------------------
/*
aws ec2 describe-instance-type-offerings --location-type availability-zone  --filters Name=instance-type,Values=t3.micro --region us-east-1 --output table
-------------------------------------------------------
|            DescribeInstanceTypeOfferings            |
+-----------------------------------------------------+
||               InstanceTypeOfferings               ||
|+--------------+--------------+---------------------+|
|| InstanceType |  Location    |    LocationType     ||
|+--------------+--------------+---------------------+|
||  t3.micro    |  us-east-1c  |  availability-zone  ||
||  t3.micro    |  us-east-1a  |  availability-zone  ||
||  t3.micro    |  us-east-1f  |  availability-zone  ||
||  t3.micro    |  us-east-1d  |  availability-zone  ||
||  t3.micro    |  us-east-1b  |  availability-zone  ||
|+--------------+--------------+---------------------+|
*/
data "aws_ec2_instance_type_offerings" "my_instance_type" {
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }
  filter {
    name = "location"
    //values = ["us-east-1a"] # aws ec2 describe-instance-type-offerings --location-type availability-zone  --filters Name=instance-type,Values=t3.micro --region us-east-1 --output table => (location: us-east-1a)
    values = ["us-east-1e"]
  }
  location_type = "availability-zone"
}

output "output_v1_1" {
  value = data.aws_ec2_instance_type_offerings.my_instance_type
}
---------------------------------------------------------------------------
