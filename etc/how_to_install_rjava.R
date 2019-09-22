###########################################################################
#
#    script_name : hot_to_install_rjava
#    author      : Gomguard
#    created     : 2019-09-23 01:00:29
#    description : desc
#
###########################################################################

# https://www.r-bloggers.com/installing-rjava-on-ubuntu/
sudo apt-get install -y default-jre
sudo apt-get install -y default-jdk
sudo R CMD javareconf
install.packages('rJava')
install.packages('RWeka')
library(rJava)
library(RWeka)

