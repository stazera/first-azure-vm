variable "resourcegroup_name" {
    type = string
    description = "Name of the resource group"
}

variable "rg_location" {
    type = string
    description = "Location of the Resource group"
}


variable "vnet_cidr" {
    type = list
    description = "IP CIDR of the vNet"
    
}

variable "vpc_location" {
    type = string
    description = "Location of the VPC"
}

variable "public_sn_name" {
    type = string
    description = "The name of the Public SN"
}

variable "public_sn_cidr" {
    type = list
    description = "The CIDR space of the Public SN"
}

variable "ip_name" {
    type = string
    description = "Name of the public IP"
}

# variable "ip_location" {
#     type = string
#     description = "Location of the public IP"
# }

variable "nic_name" {
    type = string
    description = "name of the NIC"
}

# variable "nic_location" {
#     type = string
#     description = "Location of the NIC"
# }

variable "nsg_name" {
        type = string
    description = "Name of the NSG"
}

# variable "nsg_location" {
#         type = string
#         description = "Location of the NSG"
# }