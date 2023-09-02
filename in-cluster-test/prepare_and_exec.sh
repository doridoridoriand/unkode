#!/bin/bash

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

curl -LO "https://raw.githubusercontent.com/doridoridoriand/unkode/master/in-cluster-test/get_resources.sh"
chmod +x get_resources.sh

./get_resources.sh
