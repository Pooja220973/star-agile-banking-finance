resource "aws_instance" "test-server" {
  ami = "ami-02d26659fd82cf299"
  instance_type = "t2.micro"
  key_name = "financekey"
  vpc_security_group_ids = ["sg-0174850fc5212ce6e"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./financekey.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/terraform-files/ansibleplaybook.yml"
     }
  }
