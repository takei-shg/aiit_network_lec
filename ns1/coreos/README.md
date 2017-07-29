
# first, launch http-server on this directory
http-server -p 9999

# get files from coreos
curl xxx.xxx.xxx.xxx:9999/ignition > ignition
curl xxx.xxx.xxx.xxx:9999/install.sh > install.sh

# you need to be root on coreos, to install
