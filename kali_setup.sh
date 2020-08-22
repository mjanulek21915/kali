# sudo adduser $USER vboxsf
printf "alias ECHO=\'echo\'\nalias ALIAS=\'code ~/.bash_aliases\'\nalias RL=\'source ~/.bash_aliases\'\nalias CL='reset'\nalias CD=\'code .\'" > /home/$USER/.bash_aliases
