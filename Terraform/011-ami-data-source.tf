#this part is for select in Database for the latest AMI - it is like a select based on each filter togather
-------------------------------------------------------------------------------------------------------------
data "aws_ami" "amzn_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] # aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14 => (name: al2023-ami-2023.10.20260202.2-kernel-6.1-x86_64)
  }
  filter {
    name   = "root-device-type" # aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14 => (root-device-type: ebs)
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type" # aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14 => (virtualization-type: hvm)
    values = ["hvm"]
  }
  filter {
    name   = "architecture" # aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14 => (architecture: x86_64)
    values = ["x86_64"]
  }
}
----------------------------------------------------Use it-----------------------------------------------------------------------------
resource "aws_instance" "web" {
  ami           = data.aws_ami.amzn_linux2.id
  instance_type = "t3.micro"
}
-----------------------------------------------------Obtenir information of AMI--------------------------------------------------------
PS C:\Users\Administrateur> aws ec2 describe-images  --image-ids ami-0c1fe732b5494dc14
{
    "Images": [
        {
            "PlatformDetails": "Linux/UNIX",
            "UsageOperation": "RunInstances",
            "BlockDeviceMappings": [
                {
                    "Ebs": {
                        "DeleteOnTermination": true,
                        "Iops": 3000,
                        "SnapshotId": "snap-06985786c1ab261bb",
                        "VolumeSize": 8,
                        "VolumeType": "gp3",
                        "Throughput": 125,
                        "Encrypted": false
                    },
                    "DeviceName": "/dev/xvda"
                }
            ],
            "Description": "Amazon Linux 2023 AMI 2023.10.20260202.2 x86_64 HVM kernel-6.1",
            "EnaSupport": true,
            "Hypervisor": "xen",
            "ImageOwnerAlias": "amazon",
            "Name": "al2023-ami-2023.10.20260202.2-kernel-6.1-x86_64", #--------------------------> name (al2023-ami-*-x86_64)
            "RootDeviceName": "/dev/xvda",
            "RootDeviceType": "ebs",  #--------------------------> root-device-type (ebs)
            "SriovNetSupport": "simple",
            "VirtualizationType": "hvm",  #--------------------------> virtualization-type (hvm)
            "BootMode": "uefi-preferred",
            "DeprecationTime": "2026-05-04T17:41:00.000Z",
            "ImdsSupport": "v2.0",
            "ImageId": "ami-0c1fe732b5494dc14",
            "ImageLocation": "amazon/al2023-ami-2023.10.20260202.2-kernel-6.1-x86_64",
            "State": "available",
            "OwnerId": "137112412989",
            "CreationDate": "2026-02-03T17:35:21.000Z",
            "Public": true,
            "Architecture": "x86_64",  #--------------------------> architecture (x86_64)
            "ImageType": "machine"
        }
    ]
}
