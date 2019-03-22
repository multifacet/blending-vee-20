#!/usr/bin/env bash
ssh -i xenial.rootfs.id_rsa root@$1

docker run --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler
#docker run --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 network_lambda_function.lambda_handler

exit