###########################################################################
#
#    script_name : how_to_set_sound_nvidia_on_ubuntu.R
#    author      : Gomguard
#    created     : 2019-11-03 15:35:11
#    description : desc
#
###########################################################################

# https://chairsitman17.tistory.com/4

git clone https://github.com/hhfeuer/nvhda
sudo apt-get install git

cd nvhda  
make
sudo make install
echo nvhda | sudo tee -a /etc/initramfs-tools/modules
echo "options nvhda load_state=1" | sudo tee /etc/modprobe.d/nvhda.conf
sudo update-initramfs -u
sudo aplay -l
