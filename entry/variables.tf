variable "vpc_name" {
  default = "vpc-basic"
}

variable "ak" {  default = "Coloca tu AK aqui" }
variable "sk" {  default = "Coloca tu SK aqui" }
variable "swr_login_command" {  default = "Coloca tu Login Command aqui" }

variable "region" {  default = "la-north-2" } #Mexico city2

variable "remote_exec_filename" {  default = "auto_installation_ecs_cluster.sh" }
variable "remote_exec_path" {  default = "/root" }
variable "private_key_file" {  default = "id_rsa" }

variable "app_name" {  default = "iaac" }
variable "environment" {  default = "production" }
variable "time_zone" {  default = "UTC-05:00" }
variable "number_of_azs" {  default = "2" }
variable "availability_zone1" {  default = "la-north-2a" }
variable "availability_zone2" {  default = "la-north-2c" }
variable "rds_db_type" {  default = "MySQL" }
variable "rds_db_version" {  default = "8.0" }
variable "rds_fixed_ip" {  default = "10.10.1.158" }
variable "rds_instance_mode" {  default = "single" }
variable "rds_group_type" {  default = "general" }
variable "rds_vcpus" {  default = "2" }
variable "rds_memory" {  default = "8" }
variable "rds_replication_mode" {  default = "async" }
variable "rds_init_password" {  default = "Huawei123+" }
variable "rds_volume_type" {  default = "CLOUDSSD" }
variable "rds_volume_size" {  default = "100" }
variable "rds_backup_starttime" {  default = "05:15-06:15" }
variable "rds_backup_keepdays" {  default = "180" }
variable "sg_ingress_rules" {  
    type        = map(map(any))
    default     = {
        rule1 = {from=22, to=22, proto="tcp", cidr="0.0.0.0/0", desc="SSH Remotely Login from Internet for Linux"}
        rule2 = {from=3389, to=3389, proto="tcp", cidr="0.0.0.0/0", desc="RDP Remotely Login from Internet for Windows"}
        rule3 = {from=80, to=80, proto="tcp", cidr="0.0.0.0/0", desc="Access Webserver HTTP from Internet"}
        rule4 = {from=443, to=443, proto="tcp", cidr="0.0.0.0/0", desc="Access Webserver HTTPs from Internet"}
        rule5 = {from=3306, to=3306, proto="tcp", cidr="0.0.0.0/0", desc="Access RDS from the VPC CIDR"}
        rule6 = {from=6379, to=6379, proto="tcp", cidr="0.0.0.0/0", desc="Access VPC from the VPC CIDR"}
        rule7 = {from=3000, to=3000, proto="tcp", cidr="0.0.0.0/0", desc="Access node webpage from Internet"}
    }
 }

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "subnet_name" {
  default = "subent-basic"
}

variable "subnet_cidr" {
  default = "10.10.1.0/24"
}

variable "subnet_gateway" {
  default = "10.10.1.1"
}

variable "primary_dns" {
  default = "100.125.1.250"
}

variable "secondary_dns" {
  default = "100.125.21.250"
}

variable "bandwidth_name" {
  default = "mybandwidth"
}

variable "key_pair_name" {
  default = "mykey_pair"
}

variable "cce_cluster_name" {
  default = "mycce"
}

variable "cce_cluster_flavor" {
  default = "cce.s1.small"
}

variable "node_name" {
  default = "mynode"
}

variable "node_flavor" {
  default = "s6.large.4"
}

variable "root_volume_size" {
  default = 40
}

variable "root_volume_type" {
  default = "SAS"
}

variable "data_volume_size" {
  default = 100
}

variable "data_volume_type" {
  default = "SAS"
}

variable "ecs_flavor" {
  default = "s6.large.2"
}

variable "ecs_name" {
  default = "myecs"
}

variable "os" {
  default = "CentOS 7.6"
}

variable "image_name" {
  default = "Debian 10.0.0 64bit"
}