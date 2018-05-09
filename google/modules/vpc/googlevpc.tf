
// Create VPC
resource "google_compute_network" "vpc" {
 name                    = "${var.vpcname}-vpc"
 auto_create_subnetworks = "false"
}

// Create Subnet
resource "google_compute_subnetwork" "subnet1" {
 name          = "${var.vpcname}-subnet1"
 ip_cidr_range = "${var.subnet1_cidr}"
 network       = "${var.vpcname}-vpc"
 depends_on    = ["google_compute_network.vpc"]
}
resource "google_compute_subnetwork" "subnet2" {
 name          = "${var.vpcname}-subnet2"
 ip_cidr_range = "${var.subnet2_cidr}"
 network       = "${var.vpcname}-vpc"
 depends_on    = ["google_compute_network.vpc"]
}


// VPC firewall configuration
resource "google_compute_firewall" "firewall" {
  name    = "${var.vpcname}-firewall"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}