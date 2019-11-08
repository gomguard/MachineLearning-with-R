###########################################################################
#
#    script_name : how_to_reinstall_mysql.R
#    author      : Gomguard
#    created     : 2019-11-03 14:53:04
#    description : desc
#
###########################################################################

# change source
# https://twpower.github.io/99-change-apt-get-source-server

# remove mysql from ubuntu
# https://linuxscriptshub.com/uninstall-completely-remove-mysql-ubuntu-16-04/

sudo apt-get remove --purge mysql*
  sudo apt-get purge mysql*
  sudo apt-get autoremove
sudo apt-get autoclean
sudo apt-get remove dbconfig-mysql
sudo apt-get dist-upgrade
sudo apt-get install mysql-server



# https://opentutorials.org/module/1175/7779