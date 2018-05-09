provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2web" {
  source = "./modules/ec2"
  pubsubnet1 = "${module.vpc.pubsubnet1}"
  pubsubnet2 = "${module.vpc.pubsubnet2}"
  privsubnet1 = "${module.vpc.privsubnet1}"
  privsubnet2 = "${module.vpc.privsubnet2}"
   allpubsubs = ["${split(",",module.vpc.allpubsubs)}"]
  sg_webservers = "${module.vpc.sg_webservers}"
}




