// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("google-creds.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}



module "vpc" {
  source = "./modules/vpc"
   vpcname = "${var.vpcname}"
   subnet1_cidr = "${var.subnet1_cidr}"
   subnet2_cidr = "${var.subnet2_cidr}"

}

module "vm" {
  source = "./modules/vm"
 networkname = "${module.vpc.networkname}"

}