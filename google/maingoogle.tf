// Configure the Google Cloud provider
provider "google" {
//  credentials = "${file("google-creds.json")}"
// updated for enterprise
  credentials = "${var.TF_VAR_GOOGLE_CREDENTIALS}"
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
