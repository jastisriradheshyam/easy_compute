# Hyperledger Sawtooth 1.2.3 install on Solus 4 (26 Oct 2019)

## Packages

- for secp256k1
    - autoconf
    - automake
    - pkg-config
    - m4
    - libtool
    - libtool-devel
    - python3-devel
    - openssl
    - openssl-devel
- python packages for sawtooth python binaries
    - grpcio-tools
    - grpcio
    - protobuf


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

### Making executables globals

- create /opt/sawtooth
    - `mkdir -p /opt/sawtooth`
- copy bin and cli to /opt/sawtooth
    - `sudo cp -r bin cli /opt/sawtooth`
    - Note: Run above code from sawtooth-core, so that the base directory should be `sawtooth-core`.
- from `bin` directory make soft links of sawtooth executables
    - `for f in *; do if [[ $f == *"saw"* ]]; then sudo ln -s "$(pwd)/$f" /usr/bin/$f; fi; done;`

----
# Disclaimer
As of writing Solus has openssl version of `1.0.2t` which works fine with secp256k1 library. There will be installation problem with openssl version `1.1` and beyond and they changed the API.
