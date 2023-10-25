# #!/bin/bash
# export OUTLOG="/var/log/auto-installation-log.log"
# export DEBIAN_FRONTEND=noninteractive
touch test1
# ##### START IF #############################################################################################################################################
# if cat /etc/*release | grep ^PRETTY_NAME | grep "Debian GNU/Linux 10" > /dev/null ; then
# ######## IF THE OS VERSION IS DEBIAN 10, then execute the following commands. ##############################################################################
# date > $OUTLOG 2>&1

# echo "### Update & Upgrade Start ###" >>$OUTLOG
# apt-get update >> $OUTLOG 2>&1
# apt-get -y upgrade >> $OUTLOG 2>&1
# echo "### Update & Upgrade End ###" >>$OUTLOG


# echo "### node Start ###" >>$OUTLOG
# apt-get -y install nodejs >>$OUTLOG 2>&1
# apt-get -y install npm >>$OUTLOG 2>&1
# echo "### node End ###" >>$OUTLOG

# echo "### git Start ###" >>$OUTLOG
# apt-get -y install git >>$OUTLOG 2>&1
# git clone https://github.com/JobRamos/ecommerce_mysql.git
# cd ecommerce_mysql/
# npm install 

# # npm run dev

# echo "### node End ###" >>$OUTLOG



# echo "### MySQL Client Start ###" >>$OUTLOG
# apt install gnupg >>$OUTLOG 2>&1
# wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
# dpkg -i mysql-apt-config*
# apt-get update >> $OUTLOG 2>&1

# apt -y install mysql-server
# y


# echo "### MySQL Client End ###" >>$OUTLOG

# ##### Otherwise, exit! ###############################################################################################################################
# else
#     echo "Please use Debian GNU/Linux 10 to create ECS."
#         exit 1;
# fi
# ##### END IF #########################################################################################################################################

