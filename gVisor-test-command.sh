#!/usr/bin/env bash

#sudo docker run -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128 --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler
sudo docker run -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128  --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 network_lambda_function.lambda_handler $0

#sudo docker run -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128 --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler


