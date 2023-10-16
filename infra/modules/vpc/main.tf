variable "subnet" {default = ""}
variable "zone" {default = ""}
variable "v4_cidr_blocks" {default = ""}
variable "network"{default = ""}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
resource "yandex_vpc_network" "network" {
  name = var.network
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.v4_cidr_blocks
}

output "subnet_ids" {
  description = "The ID of the VPC"
  value       = yandex_vpc_subnet.subnet.id
}
