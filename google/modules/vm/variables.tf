variable networkname {type = "list"}
variable "netzone" {
  # Arbitrary mapping of region name to number to use in
  # a VPC's CIDR prefix.
  default = ["europe-west2-a", "europe-west2-b"]
}
