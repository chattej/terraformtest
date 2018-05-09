
#  populated from tfvars file
variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-2"
}




variable "region_number" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's CIDR prefix.
  default = {
    eu-west-1      = 1
    eu-west-2      = 2
  }
}




variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
  }
}


