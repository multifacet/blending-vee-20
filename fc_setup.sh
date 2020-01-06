#!/usr/bin/env bash

TOTAL_TAPS=$(grep -A1 'fc_setup:' config.yml | tail -n1 | cut -c 17-)
NET_INTERFACE=$( grep -A2 'fc_setup:' config.yml | tail -n1 | cut -c 24-)
ROOT_FS=$(grep -A3 'fc_setup:' config.yml | tail -n1 | cut -c 14-)

#setup tap devices
./fc/setup-tap-new.sh $TOTAL_TAPS $NET_INTERFACE
./fc/copy-root-fs.sh  $TOTAL_TAPS $ROOT_FS

mkdir fc/output

#copy workloads
#scp * workloads