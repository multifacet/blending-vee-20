#!/usr/bin/env bash
docker run --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler