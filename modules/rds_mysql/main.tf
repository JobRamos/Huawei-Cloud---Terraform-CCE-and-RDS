### Provider Huawei Cloud ##

terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
}

# data "huaweicloud_enterprise_project" "enterprise_project" {
#   name = "${var.app_name}-${var.environment}"
# }

data "huaweicloud_availability_zones" "zones" {
  region      = "${var.region}"
}

data "huaweicloud_vpc" "vpc" {
  name        = "${var.vpc_name}"
}

data "huaweicloud_vpc_subnet" "subnet" {
  name        = "${var.subnet_name}"
}

data "huaweicloud_networking_secgroup" "securitygroup" {
  name        = "${var.app_name}-${var.environment}-sg"
}

data "huaweicloud_rds_flavors" "flavor" {
  db_type       = "${var.rds_db_type}"
  db_version    = "${var.rds_db_version}"
  instance_mode = "${var.rds_instance_mode}"
  vcpus         = "${var.rds_vcpus}"
  memory        = "${var.rds_memory}"
  group_type    = "${var.rds_group_type}"
}

## RDS - Create Instance Resource ##
resource "huaweicloud_rds_instance" "single_instance" {
  name              = "${var.app_name}-${var.environment}-rds"
  flavor            = "${data.huaweicloud_rds_flavors.flavor.flavors[0].name}"
  vpc_id            = "${data.huaweicloud_vpc.vpc.id}"
  subnet_id         = "${data.huaweicloud_vpc_subnet.subnet.id}"
  security_group_id = "${data.huaweicloud_networking_secgroup.securitygroup.id}"
  availability_zone = ["${var.availability_zone1}"]
  fixed_ip          = "${var.rds_fixed_ip}"

  db {
    type     = "${var.rds_db_type}"
    version  = "${var.rds_db_version}"
    password = "${var.rds_init_password}"
  }

  volume {
    type = "${var.rds_volume_type}"
    size = "${var.rds_volume_size}"
  }

  backup_strategy {
    start_time = "${var.rds_backup_starttime}"
    keep_days  = "${var.rds_backup_keepdays}"
  }
}


# output "rds_ip" {
#     value = "${huaweicloud_rds_instance.single_instance.private_ips}"
# }