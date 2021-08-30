Labs
=

This repository contains "labs": setup of virtual machines with associated provisionning.

It uses Vagrant to brings up virtual machines. Tests have been made on VirtualBox, but it should works on other supported hypervisors. If not, please report it.

These labs prepare environment for tests and experimentations. **DO NOT USE THEM IN PRODUCTION**

Available labs
-

* [Base](base/): A Win2016 DC + Win2016 server joined + Win10 client joined. Its a setup commonly used for tests in Windows environment, quite useful to fire, test, and forget.
* [Administration Tier-1, with AuthenticationPolicy and RestrictedAdmin](/admin-t1-restricted): Illustration of an administration method, on a base-like lab, for interactive administration on untrested machine.
* [Linux Compound-Authentication](/linux-compound): Highlight the use of compound authentication from a Linux station to an AD. In addition to the basic usage, it also demonstrates the use of PKINIT and a TPM in this context

Resources
-

- [DetectionLab](https://github.com/clong/DetectionLab): Vagrant & Packer scripts to build a lab environment complete with security tooling and logging best practices
