locals { # this use case of locals helps you assign same tags for multiple instances being deployed simultaneously, change these tags based on requirements
  tags = {
    OSVersion     = ""
    Functionality = ""
  }
}

#Domain join work around script
data "local_file" "input_script" {
  filename = "domainjoin.ps1"
}

#Generate an index map using the range function
locals {
  instance_count     = length(var.instance_name)
  instance_index_map = { for idx in range(local.instance_count) : idx => var.instance_name[idx] }
}

# Create domain join script for each windows instance that is to be deployed, with the instance name hardcoded in it.
resource "local_file" "file_generator" {
  for_each = local.instance_index_map
  filename = "domainjoin_${each.key}.ps1" #Create a new file with updated instance name
  # Use dynamic content to replace "HOSTNAME" with instance_name for the specific instance
  content = replace(data.local_file.input_file1.content, "HOSTNAME", each.value)
}
module "ec2-instance-windows" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.0"
  count   = length(var.instance_name)
  ami     = lookup(var.config_variables, "amiid_win")
  /* ami                    = lookup(var.config_variables, "amiid_linux") */
  instance_type          = lookup(var.config_variables, "itype")
  subnet_id              = var.subnet_id[count.index]
  private_ip             = var.assigned_ip_address[count.index]
  iam_instance_profile   = lookup(var.config_variables, "iam_profile")
  vpc_security_group_ids = [lookup(var.config_variables, "security_grp_id")] # use this line to configure a single security group
  # vpc_security_group_ids =[var.security_grp_id_2,lookup(var.config_variables, "security_grp_id")] # use this line if you want to assign 2 security groups
  # vpc_security_group_ids =[var.security_grp_id_2,var.security_grp_id_3,lookup(var.config_variables, "security_grp_id")] # use this line if you want to assign multiple security groups
  key_name = "" # Add the key-pair name to be associated with EC2 instances
  # launch_template = { #Uncomment this block if you want to provide a launch template
  #   id      = lookup(var.config_variables, "launch_template")
  #   version = "$Latest"
  # }
  # user_data = local_file.file_generator[count.index].content # Userdata windows domain join script
  # user_data = file("") # Userdata script depending on OS
  tags = merge(
    {
      "Name"       = var.instance_name[count.index]
      "AssignedIP" = var.assigned_ip_address[count.index]
    },
    local.tags
  )
  volume_tags = merge(
    {
      "Name"       = var.instance_name[count.index]
      "AssignedIP" = var.assigned_ip_address[count.index]
    },
    local.tags
  )
}
