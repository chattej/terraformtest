// Create a new instance


resource "google_compute_instance" "test" {
  count = 2
  name         = "terraform-vm-${count.index}"
  machine_type = "n1-standard-1"
// zone         = "europe-west2-a"
   zone = "${element(var.netzone, count.index)}"
   tags = ["mytvm${count.index}"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    subnetwork = "${element(var.networkname, count.index)}"
//subnetwork = "${var.networkname}"
    access_config {
      // Ephemeral IP
    }
  }



  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}