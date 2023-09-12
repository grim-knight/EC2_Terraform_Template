variable "instance_name" {
  type    = list(any) # add the list of server names in the default
  default = []
}

variable "assigned_ip_address" {
  type    = list(any)
  default = [] # Add the list of IP addresses inside the default that must be assigned to the EC2 instances
}

variable "subnet_id" {
  type    = list(any)
  default = [] # Add the list of subnets ids inside the default that must be assigned to the EC2 instances
}

variable "config_variables" {
  type = map(any)
  default = {
    security_grp_id  = "" # Add the security group id required
    amiid_win   = "" #Add the AMI id for windows
    amiid_linux = "" # Add the AMI id for Linux
    itype       = "" # Add the intance type here
    # launch_template  = "" # if you have a luanch template ID available then add that and uncomment this line
    iam_profile = "" # Add the IAM role name that must be attached to the EC2 isntances
  }
}

# Utilize the below lines, if you want to add a second security group to your ec2 instances
# variable "security_grp_id_2"{
#   type = string
#   default = ""
# }
# variable "security_grp_id_3"{
#   type = string
#   default = ""# 
# }