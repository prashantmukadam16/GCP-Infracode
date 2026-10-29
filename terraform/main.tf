module "network" {
  source = "./modules/network"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
}

module "mysql" {
  source = "./modules/mysql"

  project_id             = var.project_id
  region                 = var.region
  environment            = var.environment
  network_id             = module.network.network_id
  mysql_tier             = var.mysql_tier
  deletion_protection    = var.mysql_deletion_protection

  # Ensures the Private Service Access connection exists before Cloud SQL.
  depends_on = [module.network]
}

module "autoscaling" {
  source = "./modules/autoscaling"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  subnet_id   = module.network.app_subnet_id
}
