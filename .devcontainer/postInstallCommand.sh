#!/bin/sh

echo "Updating packages"
sudo apt update
sudo apt install -y libevent-dev
sudo apt install -y libssl-dev
sudo apt install -y libxml2-dev
sudo apt install -y libyaml-dev
sudo apt install -y libgmp-dev
sudo apt install -y libz-dev