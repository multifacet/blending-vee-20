#!/usr/bin/env bash
CONTAINER="${1:-0}"

for ((i=0; i<CONTAINER; i++))
do
  sudo docker run -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128 --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_time_lambda_function.lambda_handler $i
  sleep 10
done
