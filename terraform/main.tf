module "vpc" {
  source = "./modules/vpc"
  v4_cidr_blocks = local.v4_cidr_blocks[terraform.workspace]
  network = terraform.workspace
  subnet = "subnet-${terraform.workspace}"
  zone = local.vpc_zones[terraform.workspace]
}

module "instance"{
  source = "./modules/instance"
  name = "vm-${terraform.workspace}"
  subnet_id = module.vpc.subnet_ids
  cores = local.cores[terraform.workspace]
  memory = local.memory[terraform.workspace]
  instance_count = local.instance_count[terraform.workspace]
  platform = local.platform[terraform.workspace]
  master_instance = local.master_instances[terraform.workspace]
  depends_on = [module.vpc]
}

locals {
  v4_cidr_blocks = {
    prod = ["192.168.1.0/24"]
    stage = ["192.168.2.0/24"]
  }
  vpc_zones = {
    prod = "ru-central1-a"
    stage ="ru-central1-a"
  }
  cores = {
    prod = 2
    stage = 2
 }
  memory = {
    prod = 4
    stage = 4
  }
  instance_count = {
    prod = 2
    stage = 2
  }
  platform = {
    prod    = "standard-v1"
    stage   = "standard-v1"
  }
  master_instances = {
    prod = {
      k8s-mstr = {
        cores    = 4
        memory   = 8
        platform = "standard-v2"
      }
    }
    stage = {
      k8s-mstr = {
        cores    = 4
        memory   = 8
        platform = "standard-v2"
      }
    }
  }
}