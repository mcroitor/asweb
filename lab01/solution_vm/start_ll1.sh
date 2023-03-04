# not finished. check if qemu exists. download image

CURRENT_DIR=(pwd)
# PATH=$PATH:$CURRENT_DIR/qemu

ISO_DIR=$CURRENT_DIR/cd
IMAGE_DIR=$CURRENT_DIR/image

CREATE_IMAGE=qemu-img
EMULATOR=qemu-system-x86_64

HDD_IMAGE=debian-server.img
ISO_IMAGE=debian-11.1.0-amd64-netinst.iso
RAM_SIZE=2G
ROM_SIZE=8G

HDD=$IMAGE_DIR/$HDD_IMAGE
ISO=$ISO_DIR/$ISO_IMAGE

if [ -f $HDD]; then
	echo "virtual machine exists."
	echo "start virtual machine."
	%EMULATOR% -m %RAM_SIZE% %HDD%
	echo "done."
else
	echo "HDD image not found."
	echo "create HDD image."
	%CREATE_IMAGE% create -f vdi %HDD% %ROM_SIZE%
	echo "HDD image is created."
	
	echo "start virtual machine."
	%EMULATOR% -m %RAM_SIZE% -cdrom %ISO% %HDD%
	echo "done."
fi