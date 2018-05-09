
output "pubsubnet1" {value = "${aws_subnet.Public1.id}"}
output "pubsubnet2" {value = "${aws_subnet.Public2.id}"}
output "allpubsubs" {value = "${aws_subnet.Public2.id},${aws_subnet.Public1.id}" }
output "privsubnet1" {value = "${aws_subnet.Private1.id}"}
output "privsubnet2" {value = "${aws_subnet.Private2.id}"}
output "sg_webservers" {value = "${aws_security_group.tf_web_servers.id}"}


