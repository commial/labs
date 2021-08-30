#!/bin/sh

echo "[+] Install dependencies"
sudo pacman -Syu krb5 ibm-sw-tpm2 tpm2-abrmd tpm2-tools opensc tpm2-pkcs11

echo "[+] Prepare patched version of tpm2-pkcs11"
sudo pacman -Syu git extra/python-setuptools
git clone https://github.com/tpm2-software/tpm2-pkcs11
cd tpm2-pkcs11
git apply /home/vagrant/tpm2_pkcs11.patch
cd tools
python setup.py build
export PYTHONPATH=/home/vagrant/tpm2-pkcs11/tools/build/lib/:$PYTHONPATH
cd $HOME

echo "[+] Prepare the software TPM"
# Disable false alarms https://github.com/tpm2-software/tpm2-pkcs11/issues/655#issuecomment-781500908
export TSS2_LOG=fapi+NONE
rm -rf store/
mkdir store
tpm_server &
sudo -u tss mkdir -p /var/lib/tpm2-tss/system/keystore/policy
sudo -u tss tpm2-abrmd --tcti=mssim &
export TPM2TOOLS_TCTI=tabrmd:bus_type=system

echo "[+] Init the TPM"
tpm2_ptool init --path=~/store
tpm2_ptool addtoken --pid=1 --sopin=mysopin --userpin=myuserpin --label=label --path ~/store
export TPM2_PKCS11_STORE=$HOME/store
alias tpm2pkcs11-tool='pkcs11-tool --module /usr/lib/pkcs11/libtpm2_pkcs11.so'
tpm2pkcs11-tool --list-objects --login --pin=myuserpin

echo "[+] Import /tmp/cert.pem certificate"
openssl rsa -in /tmp/cert.pem -out /tmp/key_no_pass.pem -passin pass:dummypassword
tpm2_ptool import --userpin myuserpin --privkey /tmp/key_no_pass.pem --label label --algorithm rsa
KEYID=$(tpm2_ptool objmod --id 1 --key 258 | head -1 | sed -E "s/^[^0-9]*([0-9]+).*$/\1/")
tpm2_ptool addcert --label label --key-id $KEYID /tmp/cert.pem
tpm2pkcs11-tool --list-objects --login --pin=myuserpin
