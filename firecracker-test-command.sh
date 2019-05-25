#!/usr/bin/env bash
ssh -i xenial.rootfs.id_rsa root@$1

#run the test and redirect result to a file 

#docker run --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 network_lambda_function.lambda_handler

exit