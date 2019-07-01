#!/usr/bin/env bash

#!/bin/bash

#Usage
## sudo ./start.sh 0 100 # Will start VM#0 to VM#99.

#start="${1:-0}"

SB_ID="${1:-0}"


total="${1:-1}"

for ((i=0; i<total; i++)); do
   ./start-firecracker.sh "$i"
done


#./cleanup-firecracker.sh




