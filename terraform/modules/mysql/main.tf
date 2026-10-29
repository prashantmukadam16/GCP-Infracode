resource "google_sql_database_instance" "mysql" {
  name                = "mysql-${var.environment}"
  region              = var.region
  database_version    = "MYSQL_8_0"
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.mysql_tier
    availability_type = "REGIONAL"
    disk_type         = "PD_SSD"
    disk_size         = 20
    disk_autoresize   = true

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
  }
}

resource "google_sql_database" "app" {
  name     = "application"
  instance = google_sql_database_instance.mysql.name
}

