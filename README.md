Labs
=

This repository contains "labs": setup of virtual machines with associated provisionning.

It uses Vagrant to brings up virtual machines. Tests have been made on VirtualBox, but it should works on other supported hypervisors. If not, please report it.

These labs prepare environment for tests and experimentations. **DO NOT USE THEM IN PRODUCTION**

Available labs
-

* [Base](base/): A Win2016 DC + Win2016 server joined + Win10 client joined. Its a setup commonly used for tests in Windows environment, quite useful to fire, test, and forget.

Resources
-

- [DetectionLab](https://github.com/clong/DetectionLab): Vagrant & Packer scripts to build a lab environment complete with security tooling and logging best practices