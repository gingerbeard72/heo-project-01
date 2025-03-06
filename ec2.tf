# PostgreSQL DB Instance
resource "aws_instance" "instance" {
  ami                         = "ami-026eba2cb0d3e6856"
  instance_type               = var.instance_type
  iam_instance_profile        = "heo-Cartographer-EC2-Instance-Profile"
  key_name                    = data.aws_key_pair.cartographer-db.public_key
  subnet_id                   = data.aws_subnet.compute-private-subnet-3.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [data.aws_security_group.sec-group.id]
  root_block_device {
    delete_on_termination = false
    iops                  = 3000
    throughput            = 125
    volume_size           = 100
    volume_type           = "gp3"
  }
  tags = {
    Name                 = "Cartographer-db"
    "heo:env:service"    = "prod:cartographer-db"
    "QSConfigName-97uqz" = "heo-prod-patch-manager-default-policy"
    "ami-backup"         = true
    "heo:env:patch"      = "prod:true"
  }
  provider = aws.prod
}


# resource "aws_key_pair" "instance-key-pair" {
#   key_name   = "cartographer-db"
#   public_key = file("./cartographer-postgres.pub")
#   provider   = aws.prod
# }
