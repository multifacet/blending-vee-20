#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import print_function
import os
import sys
import subprocess
import time
import decimal
# Just a test lambda, run with:
# docker run --rm -v "$PWD":/var/task lambci/lambda:python2.7
# OR
# docker run --rm -v "$PWD":/var/task lambci/lambda:python3.6
# OR
# docker run --rm -v "$PWD":/var/task lambci/lambda:python3.7 lambda_function.lambda_handler
#sudo docker run --runtime=runsc -m 128M -e AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128 --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler

def lambda_handler(event, context):
    # context.log('Hello!')
    # context.log('Hmmm, does not add newlines in 3.7?')
    # context.log('\n')

    # print(sys.executable)
    # print(sys.argv)
    # print(os.getcwd())
    # print(__file__)
    # print(os.environ)
    # print(context.__dict__)
    # proc = subprocess.Popen(["dd",
    #                      "if=/dev/urandom",
    #                          "of=/tmp/ioload.log",
    #                          "bs=512kB",
    #                          "count=2000",
    #                          "conv=fdatasync",
    #                          "oflag=dsync"],
    #                         stderr=subprocess.PIPE)
    # out, err = proc.communicate()
    # print('I/O test:\n')
    # print(out)

    # context.log('\n')
    # print(err)

    # out, err = proc.communicate()
    # buf = err.split("\n")[-2].split(",")
    # t, s = buf[-2], buf[-1]
    # t = t.split(" ")[1]
    # # s = s.split(" ")[1]
    ioload_result = ioload_test(10, "512kB", 100)

    return {
        "ioload": ioload_result
        # "executable": str(sys.executable),
        # "sys.argv": str(sys.argv),
        # "os.getcwd": str(os.getcwd()),
        # "__file__": str(__file__),
        # "os.environ": str(os.environ),
        # "context.__dict__": str(context.__dict__),
        # "ps aux": str(subprocess.check_output(['ps', 'aux'])),
        # "event": event
    }



def fstr(f):
    """
    Convert a float number to string
    """

    ctx = decimal.Context()
    ctx.prec = 20
    d1 = ctx.create_decimal(repr(f))
    return format(d1, 'f')



def ioload_test(rd, size, cnt):
    """
    IO throughput test using dd
    Args:
            rd: no. of rounds
            size: the size of data to write each time
            cnt: the times to write in each round
            (see doc of dd)
    Return:
            IO throughput, total time spent (round 1);
            ...; IO throughput, total time spent (round N)
    """
    bufs = []
    for i in xrange(rd):
        buf = ioload(size, cnt)
        bufs.append(buf)
    
    return ";".join(bufs)

def ioload(size, cnt):
    """ One round of IO throughput test """

    
    st = time.time() * 1000
    proc = subprocess.Popen(["dd",
                             "if=/dev/urandom",
                             "of=/tmp/ioload.log",
                             "bs=%s" % size,
                             "count=%s" % cnt,
                             "conv=fdatasync",
                             "oflag=dsync"],
                            stderr=subprocess.PIPE)
    
    ed = time.time() * 1000
    out, err = proc.communicate()
    buf = err.split("\n")[-2].split(",")
    t, s = buf[-2], buf[-1]
    t = t.split(" ")[1]
    cpu = fstr(float(ed) - float(st))
    # s = s.split(" ")[1]
    return "%s,%s,%s" % (t, s, cpu)
