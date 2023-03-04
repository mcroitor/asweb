@echo off
set CURRENT_DIR=%cd%
set QEMU=%CURRENT_DIR%\qemu
set PATH=%PATH%;%QEMU%

set ISO_DIR=%CURRENT_DIR%\cd
set IMAGE_DIR=%CURRENT_DIR%\image

set CREATE_IMAGE=qemu-img.exe
set EMULATOR=qemu-system-x86_64.exe

set HDD_IMAGE=debian-server.img
set ISO_IMAGE=debian-11.1.0-amd64-netinst.iso
set RAM_SIZE=2G
set ROM_SIZE=8G

set HDD=%IMAGE_DIR%\%HDD_IMAGE%
set ISO=%ISO_DIR%\%ISO_IMAGE%

rem check strucuture

IF !EXIST %QEMU% (
	echo qemu not found. exit.
	exit
)

md %ISO_DIR%
md %IMAGE_DIR%

rem download image
cd %ISO_DIR%
wget -c https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/%ISO_IMAGE%
cd %CURRENT_DIR%


IF EXIST %HDD% (
	echo virtual machine exists.
	echo start virtual machine.
	%EMULATOR% -m %RAM_SIZE% %HDD%
	echo done.
) ELSE (
	echo HDD image not found.
	echo create HDD image.
	%CREATE_IMAGE% create -f vdi %HDD% %ROM_SIZE%
	echo HDD image is created.
	
	echo start virtual machine.
	%EMULATOR% -m %RAM_SIZE% -cdrom %ISO% %HDD%
	echo done.
)