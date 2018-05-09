
output "networkname" {value = ["${google_compute_subnetwork.subnet1.name}","${google_compute_subnetwork.subnet2.name}"]}


