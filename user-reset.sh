#!/bin/bash

backup() {
    echo "Insert backup device."
    if [ -e /dev/sdb ]; then
    	echo "Check for SD Card before proceeding!"
    fi
   	read -p "Press [Enter] when backup device is inserted."
   	if [ -e /dev/sdb1 ]; then
   		sudo mount /dev/sdb1 /mnt -o uid=1000,gid=1000
   	else
   		sudo mount /dev/sdb /mnt -o uid=1000,gid=1000
   	fi
    sleep 0.5s
    echo "Device mounted."
    read -p "Enter last name of student: " NAME
    NAME=${NAME,,}
    mkdir /mnt/$NAME
    read -p "List directories to backup (No commas!): " DIRS
    for i in ${DIRS,,}; do
       i=(${i^})
       echo "Copying files in $i..."
       cp -r /$HOME/$i /mnt/$NAME
    done
    sudo umount /mnt
    sleep 0.5s
    echo "Done. You may remove backup device."
}

erase() {
    sudo rm -Rf /home/user/
    sudo cp -R /etc/skel/ /home/user
    sudo chown -R user:user /home/user
}

run_updates() {
    sudo dpkg --configure -a
    sudo apt-get install -f
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get autoremove -y
    sudo poweroff
}

echo "Here are the contents of the home directory:"
echo
ITEMS=$(ls $HOME | grep -v *.desktop)
for i in $ITEMS; do
	if [ -d $HOME/$i ]; then
		echo "Contents of $i:"
		ls -r $HOME/$i
		echo
		sleep 0.5s
	elif [ -f $HOME/$i ]; then
		echo $i
		echo
		sleep 0.5s
	fi
done
while true; do
    read -p "Do you wish to continue? [Y/n] " YN
    case $YN in
        '' | [Yy] | [Yy][Ee][Ss] )
            erase
			run_updates
            break
            ;;
        [Nn] | [Nn][Oo] )
            backup
            ;;
        * ) echo "Please answer yes or no."
        ;;
    esac
done
exit
