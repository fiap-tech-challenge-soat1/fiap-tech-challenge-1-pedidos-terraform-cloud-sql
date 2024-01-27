variable "project" {}
variable "region" {}
provider "google" {
    project = "${var.project}"
    region = "${var.region}"
}

resource "google_sql_database_instance" "master" {
    name = "pedidos-db"
    database_version = "MYSQL_8_0"
    region = "${var.region}"
    settings {
        activation_policy = "ALWAYS"
        availability_type = "ZONAL"
        disk_autoresize       = false
        disk_autoresize_limit = 0
        disk_size             = 10
        disk_type             = "PD_HDD"
        ip_configuration {
            ipv4_enabled    = false
            private_network = "projects/${var.project}/global/networks/default"
        }
        pricing_plan = "PER_USE"
        tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
    name = "pedidos-db"
    instance = "${google_sql_database_instance.master.name}"
    charset = "utf8"
    collation = "utf8_general_ci"
}

resource "google_firestore_database" "database" {
  project                 = "${var.project}"
  name                    = "pagamentos-db"
  location_id             = "southamerica-east1"
  type                    = "FIRESTORE_NATIVE"
  delete_protection_state = "DELETE_PROTECTION_ENABLED"
}

resource "google_sql_database_instance" "producao-instance" {
    name = "producao-db"
    database_version = "MYSQL_8_0"
    region = "${var.region}"
    settings {
        activation_policy = "ALWAYS"
        availability_type = "ZONAL"
        disk_autoresize       = false
        disk_autoresize_limit = 0
        disk_size             = 10
        disk_type             = "PD_HDD"
        ip_configuration {
            ipv4_enabled    = false
            private_network = "projects/${var.project}/global/networks/default"
        }
        pricing_plan = "PER_USE"
        tier = "db-f1-micro"
  }
}

resource "google_sql_database" "producao-db" {
    name = "producao-db"
    instance = "${google_sql_database_instance.producao-instance.name}"
    charset = "utf8"
    collation = "utf8_general_ci"
}