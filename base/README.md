Base lab
=

This lab contains:
* DC: Windows 2016 server, DC of a domain "windomain.local"
* SRV: Windows 2016 server, joined to the domain
* Client: Windows 10 client, joined to the domain

This lab does not need an Internet connection (once the box have been retrieved).

Setup
-

The DC must be created before the others:
```
$ vagrant up dc --provision
```

The SRV and the Client can be created in parallel:
```
$ vagrant up srv client --provision
```

Usage
-

The user `windomain.local\vagrant:vagrant` is able to RDP.
For instance, one can log-in on the Client, then `mstsc` on `srv`, with the `vagrant` account.
