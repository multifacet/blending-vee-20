import os
import sys
import subprocess
import threading
import logging
from threading import Thread
import yaml
from subprocess import Popen, PIPE
import multiprocessing


def process_output(file, stdout, test):

    if test == 'net':
        subs = 'sender'
        output = stdout.decode('utf-8').splitlines()
        res = list(filter(lambda x: subs in x, output))
        # print(res[0].split("  "))
        res = list(filter(lambda x: "/" in x, res[0].split("  ")))
        # print(res[0])
        f = open(file, "a+")
        f.write(str(res[0]) + ",")
        f.close()

def test(id, runtime, test_name, output_file, hostname, port):
    global process
    # print(cfg['net_test'])
    port = int(port) + id
    if runtime == 'fc':
        num1 = (4 * id + 2) / 256
        num2 = (4 * id + 1) % 256
        vm_ip = "169.254." + str(num1) + "." + str(num2)
        process = subprocess.Popen(["./fc.sh", str(vm_ip), str(test_name),
                                    str(hostname), str(port)],
                                   stdout=PIPE, stderr=PIPE)
    elif runtime == 'runc' or runtime.startswith('runsc'):
        process = subprocess.Popen(["./container.sh", str(id), str(test_name),
                                    str(runtime), str(hostname), str(port)],
                                   stdout=PIPE, stderr=PIPE)
    elif runtime == 'host':
        # print("hello")
        process = subprocess.Popen(["./host.sh", str(test_name),
                                    str(hostname), str(port)],
                                   stdout=PIPE, stderr=PIPE)
    stdout, stderr = process.communicate()

    if len(stderr) == 0:
        print(stdout.decode('utf-8').splitlines())
        # stdout, stderr
        #q.put(stdout)
        #process_output(output_file, stdout, test_name)
        #return stdout
    else:
        print(stderr)
        sys.exit()

def main():
    if len(sys.argv) < 4:
        print("Invalid arguements\nUsage: python run_test.py <instances> <runtime{fc, runc, runsc-kvm, runsc-ptrace, host}> <test_name in{net, cpu, read, write, mem, mem_unmap}>")
        sys.exit()

    instances = int(sys.argv[1])
    runtime = str(sys.argv[2])
    test_name = str(sys.argv[3])
    output_file = runtime +"_"+ test_name + ".out"
    q = multiprocessing.Queue(maxsize=0)

    f = open(output_file, "a+")
    f.write("\n"+str(instances)+ " instance(s)\n")
    f.close()

    # #print(threads)
    # for i in range(instances):
    #     worker = Worker(q)
    #     worker.daemon = True  # setting threads as "daemon" allows main program to
    #     # exit eventually even if these dont finish
    #     # correctly.
    #     worker.start()
    #     #threads.append(worker)
    #
    # count = 0
    # for i in range(instances):
    #     q.put((count, runtime, test_name, output_file))
    #     count = count + 1
    #
    # #wait until the queue has been processed
    # q.join()

    hostname =""
    port = 5201

    with open("../config.yml", 'r') as ymlfile:
        cfg = yaml.load(ymlfile, Loader=yaml.FullLoader)

    for item, val in cfg['net_test'].items():
        # print(item)
        if item == 'IP':
            hostname = val

        if item == 'port':
            port = val

    jobs = []
    for i in range(instances):
        p = multiprocessing.Process(target=test, args=(i, runtime, test_name, output_file, hostname, port))
        jobs.append(p)
        p.start()
        process_output(output_file, q.get(), test_name)


    for job in jobs:
        job.join()

    logging.info('Done!')


if __name__ == '__main__':
    main()