UoMImage ReadMe
================

Overview
--------
The object of this repository is to have a single way to create disk images using a single set of files. The disk images currently use a kickstart file as their basis. That file is stored in the 'http' directory at the root repository level. This is currently used for centos 7 installations and is currently capable of building Docker and Virtualbox images.

Additions to any of the built images can be created by using the Bash scripts in the 'scripts' directory.


Building Virtualbox Images
--------------------------
Making use of the main kickstart file, the program Packer is used to build the image. Packer makes use of JSON files and Vagrant.

To build a vagrant box image the following command can be used...

	packer build ./templates/template-base.json

Once that has finished you should have a centos7-\*.box file. To use this file for starting up a Virtualbox machine you can use...

	mkdir vagrant; cd vagrant
	vagrant init ../centos7-*.box
	vagrant up


Building Docker Images
----------------------
This can be done by using the scripts in the 'docker' directory. It requires the main kickstart file and optionally using the additions scripts. It also requires the livemedia-creator program and the docker service to be running. It also requires the boot.iso which will be automatically downloaded by the docker scripts if it doesn't exist.
# UoMImage_Jenkins
