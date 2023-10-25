# Configure the HUAWEI CLOUD provider.

provider "huaweicloud" {
  region     = var.region #Mexico city2 
  access_key = var.ak
  secret_key = var.sk

}

# networking resources
resource "huaweicloud_vpc" "myvpc" {
  name = var.vpc_name
  cidr = var.vpc_cidr
}

resource "huaweicloud_vpc_subnet" "mysubnet" {
  name       = var.subnet_name
  cidr       = var.subnet_cidr
  gateway_ip = var.subnet_gateway

  # dns is required for cce node installing
  primary_dns   = var.primary_dns
  secondary_dns = var.secondary_dns
  vpc_id        = huaweicloud_vpc.myvpc.id
}


## Security Group Resource ##
resource "huaweicloud_networking_secgroup" "securitygroup" {
  region               = "${var.region}"
  name                 = "${var.app_name}-${var.environment}-sg"
  description          = "${var.app_name}-${var.environment} security group"
  # enterprise_project_id  = "${data.huaweicloud_enterprise_project.enterprise_project.id}"
  delete_default_rules = true
}

## Security Group Rule INGRESS Resource ##
resource "huaweicloud_networking_secgroup_rule" "allow_rules_ingress_main" {
  for_each          = "${var.sg_ingress_rules}"
  region            = "${var.region}"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = each.value.from
  port_range_max    = each.value.to
  protocol          = each.value.proto
  remote_ip_prefix  = each.value.cidr
  description       = each.value.desc
  security_group_id = "${huaweicloud_networking_secgroup.securitygroup.id}"
}

## Security Group Rule EGRESS Resource ##
resource "huaweicloud_networking_secgroup_rule" "allow_rules_egress" {
  region            = "${var.region}"
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${huaweicloud_networking_secgroup.securitygroup.id}"
}

# rds database
module "rds_mysql" {
  source               = "../modules/rds_mysql/"
  depends_on           = [huaweicloud_vpc.myvpc, huaweicloud_vpc_subnet.mysubnet, huaweicloud_networking_secgroup.securitygroup]
  app_name             = "${var.app_name}"
  environment          = "${var.environment}"
  region               = "${var.region}"
  number_of_azs        = "${var.number_of_azs}"
  availability_zone    = "${var.availability_zone1}"
  availability_zone1   = "${var.availability_zone1}"
  availability_zone2   = "${var.availability_zone2}"
  vpc_name             = "${var.vpc_name}"
  subnet_name          = "${var.subnet_name}"
  rds_db_type          = "${var.rds_db_type}"
  rds_db_version       = "${var.rds_db_version}"
  rds_fixed_ip         = "${var.rds_fixed_ip}"
  rds_instance_mode    = "${var.rds_instance_mode}"
  rds_group_type       = "${var.rds_group_type}"
  rds_vcpus            = "${var.rds_vcpus}"
  rds_memory           = "${var.rds_memory}"
  rds_replication_mode = "${var.rds_replication_mode}"
  rds_init_password    = "${var.rds_init_password}"
  rds_volume_type      = "${var.rds_volume_type}"
  rds_volume_size      = "${var.rds_volume_size}"
  rds_backup_starttime = "${var.rds_backup_starttime}"
  rds_backup_keepdays  = "${var.rds_backup_keepdays}"
  time_zone            = "${var.time_zone}"
}

# cce cluster creation
resource "huaweicloud_vpc_eip" "myeip1" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = var.bandwidth_name
    size        = 50
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

data "huaweicloud_availability_zones" "myaz" {}

resource "huaweicloud_cce_cluster" "mycce" {
  name                   = var.cce_cluster_name
  flavor_id              = var.cce_cluster_flavor
  vpc_id                 = huaweicloud_vpc.myvpc.id
  subnet_id              = huaweicloud_vpc_subnet.mysubnet.id
  container_network_type = "overlay_l2"
  eip                    = huaweicloud_vpc_eip.myeip1.address
  cluster_version        = "v1.25"  
}

## Security Group Rule INGRESS Resource ##
resource "huaweicloud_networking_secgroup_rule" "allow_rules_ingress_cce" {
  for_each          = "${var.sg_ingress_rules}"
  region            = "${var.region}"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = each.value.from
  port_range_max    = each.value.to
  protocol          = each.value.proto
  remote_ip_prefix  = each.value.cidr
  description       = each.value.desc
  security_group_id = "${huaweicloud_cce_cluster.mycce.security_group_id}"
}

## Security Group Rule EGRESS Resource ##
resource "huaweicloud_networking_secgroup_rule" "allow_rules_egress_cce" {
  region            = "${var.region}"
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${huaweicloud_cce_cluster.mycce.security_group_id}"
}


# ecs nodes resources 
resource "huaweicloud_compute_keypair" "keypair" {
  name       = "${var.region}-keypair"
  public_key = file("${path.root}/id_rsa.pub")
}

resource "huaweicloud_vpc_eip" "myeip2" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = var.bandwidth_name
    size        = 50
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_cce_node" "mynode" {
  cluster_id        = huaweicloud_cce_cluster.mycce.id
  name              = var.node_name
  flavor_id         = var.node_flavor
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  key_pair          = huaweicloud_compute_keypair.keypair.id
  os                = var.os
  runtime           = "docker"
  

  root_volume {
    size       = var.root_volume_size
    volumetype = var.root_volume_type
  }
  data_volumes {
    size       = var.data_volume_size
    volumetype = var.data_volume_type
  }

  // Assign existing EIP
  eip_id = huaweicloud_vpc_eip.myeip2.id
}

# swr organization
resource "huaweicloud_swr_organization" "my_organization" {
  name = "terraform-organization"
}


################## Declaring Module provisioner Working #### DONE ###########
module "provision_remote_exec_image" {
  source              = "../modules/provision_remote_exec/"
  # depends_on          = [huaweicloud_cce_node_attach.test]
  depends_on          = [huaweicloud_cce_node.mynode, module.rds_mysql, huaweicloud_swr_organization.my_organization]
  ecs_instance_eip    = "${huaweicloud_vpc_eip.myeip2.address}"
  private_key_file    = "${var.private_key_file}"
  remote_exec_path    = "${var.remote_exec_path}"
  remote_exec_filename= "${var.remote_exec_filename}"
  swr_login_command   = "${var.swr_login_command}"
}




