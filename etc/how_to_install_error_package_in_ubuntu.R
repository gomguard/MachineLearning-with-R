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
# sudo apt install libcurl4-openssl-dev libssl-dev libxml2-dev
# sudo apt-get install r-cran-curl r-cran-openssl r-cran-xml2
# sudo apt-get upgrade pkg-config

# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
# gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
# gpg -a --export E084DAB9 | sudo apt-key add -
# sudo apt-get install r-base-dev

# echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic/" | sudo tee -a /etc/apt/sources.list
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'

# https://www.digitalocean.com/community/tutorials/how-to-install-r-on-ubuntu-18-04



# Error message
# Error in library(tidyverse) : 
#   ‘tidyverse’이라고 불리는 패키지가 없습니다
# 실행이 정지되었습니다
# Warning in install.packages :
#   installation of package ‘tidyverse’ had non-zero exit status
# 
# The downloaded source packages are in
# 	‘/tmp/RtmpA6UYIi/downloaded_packages’

getPackages <- function(packs){
  packages <- unlist(
    # Find (recursively) dependencies or reverse dependencies of packages.
    tools::package_dependencies(packs, available.packages(),
                                which=c("Depends", "Imports"), recursive=TRUE)
  )
  packages <- union(packs, packages)
  return(packages)
  }

# https://blog.acronym.co.kr/466
# sudo apt-cache search tidyverse
# sudo apt-get install r-cran-tidyverse

# 출처: https://rfriend.tistory.com/441?category=601862 [R, Python 분석과 프로그래밍의 친구 (by R Friend)]

