module "network" {
  source              = "./modules/network"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b"]
  project_name        = "elham"
}



module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.network.vpc_id
}

module "bastion" {
  source             = "./modules/bastion"
  subnet_id          = module.network.public_subnet_ids[0]
  security_group_id  = module.security_group.security_group_id
  key_name           = "elham-ec2-key"
}

module "ec2" {
  source = "./modules/ec2"
  # Existing vars
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id  = module.security_group.security_group_id
  bastion_ip         = module.bastion.public_ip
}

module "lb" {
  source              = "./modules/lb"
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
  ec2_public_map      = module.ec2.public_instance_map
  ec2_private_map     = module.ec2.private_instance_map
  security_group_id   = module.security_group.security_group_id
}
