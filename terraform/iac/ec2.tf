module "key-pair" {
  source  = "cloudposse/key-pair/aws"
  version = "0.20.0"

  ssh_public_key_path   = "/Users/vincent/Documents/Projects/GT-CDS/terraform/iac/secrets"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"

  context = module.this.context
}

module "gitlab_instance" {
  source = "cloudposse/ec2-instance/aws"

  version = "1.4.1"

  ssh_key_pair                = module.key-pair.key_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_id                      = module.vpc.vpc_id
  security_groups             = [module.sg_gitlab_runner.id]
  subnet                      = module.web_app-subnets.public_subnet_ids[0]
  associate_public_ip_address = true
  assign_eip_address          = false
  security_group_enabled      = false
  ebs_optimized               = false
  monitoring                  = false
  source_dest_check           = false
  instance_profile_enabled    = true
  instance_profile            = aws_iam_instance_profile.gitlab_profile.name
  user_data                   = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install net-tools -y
              sudo apt install unzip -y
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
              sudo apt install docker.io -y
              chmod 666 /var/run/docker.sock
              sudo systemctl enable docker
              sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.3/2024-04-19/bin/linux/amd64/kubectl
              sudo chmod +x kubectl
              sudo mv kubectl /usr/local/bin
              curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
              sudo apt-get install gitlab-runner
            EOF

  context = module.this.context

  tags = {
    Name = "${local.env}-cds-gitlab"
  }
}