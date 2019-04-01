from __future__ import print_function
import os
import sys
import subprocess
import json
import time
import socket
import random
import uuid

# Just a test lambda, run with:
# docker run --rm -v "$PWD":/var/task lambci/lambda:python2.7
# OR
# docker run --rm -v "$PWD":/var/task lambci/lambda:python3.6
# OR
# docker run --rm -v "$PWD":/var/task lambci/lambda:python3.7 lambda_function.lambda_handler
# sudo docker run --runtime=runsc --rm -v  /root/docker/task:/var/task lambci/lambda:python2.7 network_lambda_function.lambda_handler 2 123.698796 5201 > out.txt

def lambda_handler(event, context):
    # context.log('Hello!')
    # context.log('Hmmm, does not add newlines in 3.7?')
    # context.log('\n')
    # #thread_id = sys.argv[2]
    # print(sys.executable)
    # print(sys.argv)
    # print(os.getcwd())
    # print(__file__)
    # print(os.environ)
    # print(context.__dict__)
    thread_id = sys.argv[2]
    server_ip = "128.104.222.157"
    port = 5201 + int (thread_id)

    print(port)

    network = network_test(server_ip, port)
    return {
        "network": network
        # "executable": str(sys.executable),
        # "sys.argv": str(sys.argv),
        # "os.getcwd": str(os.getcwd()),
        # "__file__": str(__file__),
        # "os.environ": str(os.environ),
        # "context.__dict__": str(context.__dict__),
        # "ps aux": str(subprocess.check_output(['ps', 'aux'])),
        # "event": event
    }



def network_test(server_ip, port):
    """
    Network throughput test using iperf
    Args:
            port_offset: the offset of the port number;
            server_ip: the IP of the iperf server
    Return:
            throughput in bits, mean rtt, min rtt, max rtt
            (see doc of iperf)
    """
    sp = subprocess.Popen(["./iperf3",
                           "-c",
                           server_ip,
                           "-p",
                           str(port),
                           "-l",
                           "-t",
                           "1",
                           "-Z",
                           "-J"],
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)
    out, err = sp.communicate()
    #print(out)
    _d = json.loads(out)["end"]
    sender = _d["streams"][0]["sender"]
    bps = str(sender["bits_per_second"])
    maxr = str(sender["max_rtt"])
    minr = str(sender["min_rtt"])
    meanr = str(sender["mean_rtt"])
    return ",".join([bps, meanr, minr, maxr])
