
# Create a new load balancer
resource "aws_elb" "web_lb" {
  name               = "web-terraform-elb"
  subnets = ["${var.pubsubnet1}", "${var.pubsubnet2}"]
  security_groups = ["${var.sg_webservers}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances                   = ["${aws_instance.tfwebserver1.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "web-terraform-elb"
  }
}




##########Create Web Servers


data "template_file" "user_data" {
  template = "${file("${path.module}/userdata.txt")}"
}


variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type = "list"
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}



resource "aws_instance" "tfwebserver1" {
  count = 2
  ami           = "ami-dff017b8"
  instance_type = "t2.micro"
# subnet_id      = "${count.index == 0 ? var.pubsubnet1 : var.pubsubnet2}"
  subnet_id      = "${element(var.allpubsubs, count.index)}"
 

 key_name = "jiohnchattkeypair"
  vpc_security_group_ids = ["${var.sg_webservers}"]
  #availability_zone = "${element(var.azs, count.index)}"
  user_data = "${data.template_file.user_data.rendered}"
  tags {
    "Name" = "tf_web_${count.index}"
  }
  
}


