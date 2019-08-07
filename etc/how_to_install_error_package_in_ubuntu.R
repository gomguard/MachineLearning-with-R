# install.packages("openssl") led to this:
#   
#   ------------------------- ANTICONF ERROR ---------------------------
#   Configuration failed because openssl was not found. Try installing:
#   
#   deb: libssl-dev (Debian, Ubuntu, etc)
# rpm: openssl-devel (Fedora, CentOS, RHEL)
# csw: libssl_dev (Solaris)
# brew: openssl (Mac OSX)
# If openssl is already installed, check that 'pkg-config' is in your
# PATH and PKG_CONFIG_PATH contains a openssl.pc file. If pkg-config
# is unavailable you can set INCLUDE_DIR and LIB_DIR manually via:
#   R CMD INSTALL --configure-vars='INCLUDE_DIR=... LIB_DIR=..
# So then to linux prompt:
# $ sudo apt-get install libssl-dev
# 
# and then back to R
# install.packages("openssl")


# execute this
# $ sudo apt-get install libssl-dev
