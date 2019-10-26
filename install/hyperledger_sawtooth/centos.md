# Hyperledger Sawtooth 1.2.3 install on CentOS 8

## Packages
The specified packages has to be installed before starting with next section

- for secp256k1
    - autoconf
    - automake
    - pkg-config
    - m4
    - libtool
    - libtool-devel
    - libtool-ltdl
    - libtool-ltdl-devel
    - python3-devel
    - openssl
    - openssl-devel
    - libffi
    - libffi-devel
- python packages for sawtooth python binaries
    - grpcio-tools
    - grpcio
    - protobuf

## Installing `secp256k1` python package:

- clone the specific repository
    - https://github.com/stfairy/secp256k1-py.git
- change to secp256k1-py
    - `cd secp256k1-py`
then run
    - `sudo python3 setup.py install`

### Extra info:
specific commit:
https://github.com/stfairy/secp256k1-py/commit/01d6c8e730037f3d31a17ed3812194c83a5e635c

this repo has made the changes to the libsecp256k1 repo url by changing the commit id in the setup file which makes the secp256k1 work with latest openssl having version 1.1 or above.

## Installation:
- Install sawtooth-sdk
    - `sudo pip3 install sawtooth-sdk`
- change directory to opt
    - `cd /opt`
- clone the sawtooth-core
    - `git clone https://github.com/hyperledger/sawtooth-core.git`
- change directory to sawtooth-core
    - `cd sawtooth-core`
- checkout to specific version (here 1.2.3)
    - `git checkout v1.2.3`
- set the path (this will set the temporary path, will get resetted after terminal session runs out, to make it premanent add this to ~/.bashrc)
    - `PATH=$PATH:/opt/sawtooth-core/bin`
- change directory to bin
    - `cd bin`
- generate proto files
    - `./protogen`
- change directory to cli
    - `cd ../cli`
- clean previous setup stuff
    - `sudo python3 setup.py clean --all`
- build the python files for cli stuff
    - `sudo python3 setup.py build`
- now test the sawtooth by running sawtooth commands
