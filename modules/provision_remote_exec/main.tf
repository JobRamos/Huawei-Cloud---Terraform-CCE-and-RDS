### Provider Huawei Cloud ## 
terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = "1.40.2"
    }
  }
}

## Provisioner for LAMP auto-installation-scripts.sh  ##
resource "null_resource" "provision" {

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      agent       = false
      user        = "root"
      private_key = file("${path.root}/${var.private_key_file}") ## Please place the private_key in the PATH "entry/XXXX" ##
      host        = "${var.ecs_instance_eip}"  ## the EIP address of the ECS ##
    }

    inline = [
      ### Execute the commands in the Target ECS ###
      "touch testfile",

      "export OUTLOG='/var/log/auto-installation-log.log'",
      "echo '### Update & Upgrade Start ###' >>$OUTLOG",
      "yum -y update >> $OUTLOG 2>&1",
      # "yum -y upgrade >> $OUTLOG 2>&1",

      "echo '### node Start ###' >>$OUTLOG",
      "yum -y install nodejs >>$OUTLOG 2>&1",
      "yum -y install npm >>$OUTLOG 2>&1",
      
      "echo '### git Start ###'>>$OUTLOG",
      "yum -y install git >>$OUTLOG 2>&1",
      "git clone https://github.com/JobRamos/ecommerce_mysql.git",
      "cd ecommerce_mysql/",
      "npm install" ,

      "echo '### MySQL Start ###'>>$OUTLOG",
      "curl -sSLO https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm",
      "md5sum mysql80-community-release-el7-5.noarch.rpm",
      "sudo rpm -ivh mysql80-community-release-el7-5.noarch.rpm",
      "sudo yum -y install mysql-server",
      "sudo systemctl start mysqld",

      "mysql --user=root --host=10.10.1.158 --password=Huawei123+ -e 'create database db_demo';",

      "cd ecommerce_mysql/",
      "mysql --user=root --host=10.10.1.158 --password=Huawei123+ db_demo < db_demo.sql",

      # "cd config/",
      # "sed -i '6i    host: ${var.rds_ip},' database.js",
      # "cd ..",

      "docker build -t web-app-cce .",
      # "docker run -d -p 3000:3000 web-app-cce",

      "${var.swr_login_command}",
      "docker tag web-app-cce:latest swr.la-north-2.myhuaweicloud.com/terraform-organization/web-app-cce:latest",
      "docker push swr.la-north-2.myhuaweicloud.com/terraform-organization/web-app-cce:latest"
    ]
  }
}
