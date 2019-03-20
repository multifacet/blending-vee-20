#!/usr/bin/env bash

#starts multiple iperf servers

#change the IP of the server running iperf3
SERVER_IP="128.104.222.238"

let START_PORT=5201

COUNT="${1:-0}"

for ((i=0; i<COUNT; i++))
do
  iperf3 -s -p $((START_PORT+i)) &
done