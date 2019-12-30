#!/usr/bin/env bash

#move the config file for gVisor, restart docker
pip install PyYAML
mv daemon.json /etc/docker/daemon.json
sudo systemctl restart docker

#create read_file for the read workload
./workloads/microbenchmarks/write 10 20
mv test workloads/microbenchmarks/read_file

#build the benchmark images for memory, LLCProbe, read and write
docker build -t micro-bench  -f workloads/microbenchmarks/Dockerfile.micro

#build image for network and sysbench
docker build -t net-sysbench  -f workloads/microbenchmarks/Dockerfile.net
