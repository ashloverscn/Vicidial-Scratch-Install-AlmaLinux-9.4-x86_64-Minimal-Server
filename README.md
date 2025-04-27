# Vicidial-Scratch-Install-AlmaLinux-9.X-x86_64-Minimal-Server

# Install VirtualBox and VirtualBox-Addons and grab 
# my scratch installation virtual machine from here
https://mega.nz/file/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

FOR ANY HELP CONTACT 

PhNo1: +917278963247 (whatsapp)/PhNo2: +918777246851 (whatsapp)

www.facebook.com/ashishsharma1992

http://www.youtube.com/@ashloverscn

HOW TO INSTALL :
## root permission needed
sudo su

#set your own speific timezone under which you are

tee -a  ~/.bashrc <<EOF

hostnamectl set-hostname lab.go2dial.com

EOF

chmod +x ~/.bashrc

timedatectl set-timezone Asia/Kolkata

cd /usr/src

yum -y install wget git

wget https://github.com/ashloverscn/Vicidial-Scratch-Install-AlmaLinux-9.X-x86_64-Minimal-Server/raw/main/install.sh

chmod +x install.sh

./install.sh

# run install again after reboot
/usr/src/./install.sh

/usr/src/archive./cleanup.sh

## alternatively if not working use git clone
sudo su

#set your own speific timezone under which you are

tee -a  ~/.bashrc <<EOF

hostnamectl set-hostname lab.go2dial.com

EOF

chmod +x ~/.bashrc

timedatectl set-timezone Asia/Kolkata

cd /usr/src

yum -y install wget git

git clone https://github.com/ashloverscn/Vicidial-Scratch-Install-AlmaLinux-9.X-x86_64-Minimal-Server.git

cd Vicidial-Scratch-Install-AlmaLinux-9.X-x86_64-Minimal-Server

chmod +x install.sh

./install.sh

# run install again after reboot
/usr/src/./install.sh

/usr/src/archive/./cleanup.sh






