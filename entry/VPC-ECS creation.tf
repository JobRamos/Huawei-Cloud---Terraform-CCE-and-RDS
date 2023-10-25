# # Configure the HUAWEI CLOUD provider.
# provider "huaweicloud" {
#   region     = "la-north-2"
#   access_key = "BVJJOKERVFQTWJTUHRHB"
#   secret_key = "gYJrIAsjutlgqu2HlQDENgflaBazvlSu3uvEFxef"
# }

# # Create a VPC.
# resource "huaweicloud_vpc" "example" {
#   name = "terraform_vpc"
#   cidr = "192.168.0.0/16"
# }

# # Create an ECS.
# data "huaweicloud_availability_zones" "myaz" {}

# data "huaweicloud_compute_flavors" "myflavor" {
#   availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
#   performance_type  = "normal"
#   cpu_core_count    = 2
#   memory_size       = 4
# }

# data "huaweicloud_images_image" "myimage" {
#   name        = "Ubuntu 18.04 server 64bit"
#   most_recent = true
# }

# data "huaweicloud_vpc_subnet" "mynet" {
#   name = "subnet-default"
# }


# resource "random_password" "password" {
#   length           = 16
#   special          = true
#   override_special = "!@#$%*"
# }

# resource "huaweicloud_compute_instance" "basic" {
#   name              = "basic"
#   admin_pass        = random_password.password.result
#   image_id          = data.huaweicloud_images_image.myimage.id
#   flavor_id         = data.huaweicloud_compute_flavors.myflavor.ids[0]
#   availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
#   security_groups   = ["Sys-FullAccess"]

#   network {
#     uuid = data.huaweicloud_vpc_subnet.mynet.id
#   }
# }
