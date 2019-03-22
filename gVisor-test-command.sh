#!/usr/bin/env bash

sudo docker run --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler
#sudo docker run --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 network_lambda_function.lambda_handler

