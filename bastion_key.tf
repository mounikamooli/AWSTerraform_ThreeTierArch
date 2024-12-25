# keypair for bastion

# generate tls private key locally

resource "tls_private_key" "three_tier_bastion_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# save the privatekey locally for ssh access

resource "local_file" "three_tier_bastion_key" {
  content = tls_private_key.three_tier_bastion_key.private_key_pem
  filename = "D:/Aravind/MyCourses/Terraform/AWSTerraform_ThreeTierArch/three_tier_bastion_key.pem"
  file_permission = "0400"
}

# generate aws keypair using public key created

resource "aws_key_pair" "three_tier_bastion_key" {
  key_name = var.key_name
  public_key = tls_private_key.three_tier_bastion_key.public_key_openssh
}
