#!/usr/bin/env bash

#make workloads
(cd workloads/LLCProbe && make cprobe)
(cd workloads/microbenchmarks/ && make)
mv workloads/LLCProbe/cprobe workloads/microbenchmarks/

pip install PyYAML
sudo apt install sysbench
sudo apt install iperf3

#move the config file for test-scripts, restart docker

mv daemon.json /etc/docker/daemon.json
sudo systemctl restart docker

#create read_file for the read workload
./workloads/microbenchmarks/write 10 20
mv test workloads/microbenchmarks/read_file

#build the benchmark images for memory, LLCProbe, read and write
docker build -t micro-bench  -f workloads/microbenchmarks/Dockerfile.micro . 

#build image for network and sysbench
docker build -t net-sysbench  -f workloads/microbenchmarks/Dockerfile.net .
