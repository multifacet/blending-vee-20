from __future__ import print_function
import os
import sys
import subprocess
import threading
import logging
from queue import Queue
from threading import Thread
import yaml
from subprocess import Popen, PIPE


class Worker(Thread):
    def __init__(self, queue):
        Thread.__init__(self)
        self.queue = queue

    def process_output(self, file, stdout, test):
        if test == 'net':
            subs = 'sender'
            output = stdout.decode('utf-8').splitlines()
            res = list(filter(lambda x: subs in x, output))
            #print(res[0].split("  "))
            res = list(filter(lambda x: "/" in x, res[0].split("  ")))
            #print(res[0])
            f = open(output_file, "a+")
            f.write(str(res[0]) + ",")
            f.close()


        return

    def run(self):
        done = False
        while not done:
            if self.queue.empty():
                continue
            id, runtime, test_name, output_file = self.queue.get()

            hostname = ""
            port = 5201
            global process
            with open("../config.yml", 'r') as ymlfile:
                cfg = yaml.load(ymlfile, Loader=yaml.FullLoader)

            #print(cfg['net_test'])
            for item, val in cfg['net_test'].items():
                #print(item)
                if item == 'IP':
                    hostname = val

                if item == 'port':
                    port = val + id

            if runtime == 'fc':
                num1 = (4 * id + 2) / 256
                num2 = (4 * id + 1) % 256
                vm_ip = "169.254." + str(num1) + "." + str(num2)
                process = subprocess.Popen(["./fc.sh",  str(vm_ip), str(test_name),
                                           str(hostname), str(port)],
                                           stdout=PIPE, stderr=PIPE)
            elif runtime == 'runc' or runtime.startswith('runsc'):
                process = subprocess.Popen(["./container.sh", str(id), str(test_name),
                                            str(runtime), str(hostname), str(port)],
                                           stdout=PIPE, stderr=PIPE)
            elif runtime == 'host':
                #print("hello")
                process = subprocess.Popen(["./host.sh", str(test_name),
                                            str(hostname), str(port)],
                                           stdout=PIPE, stderr=PIPE)
            stdout, stderr = process.communicate()

            if len(stderr) ==0:
                print(stdout.decode('utf-8').splitlines())
                #stdout, stderr
               # self.process_output(output_file, stdout, test_name)
            else:
                print(stderr)
                sys.exit()
            # with open(output_file, "wb", 0) as out:
            #    subprocess.Popen(["./test-scripts-test-command.sh", str(id)], stdout=out, stderr=subprocess.STDOUT)
            #cpu/fio
            #output = subprocess.call(["./test-scripts-test-command.sh",str(id)])
            #print(output)
            #net
            #output= subprocess.call(["./test-scripts-test-command.sh", str(hostname), str(port), str(id)])
            #print (output)
            #session = subprocess.Popen(["./test-scripts-test-command.sh", str(id)], stdout=PIPE, stderr=PIPE)
                #net
                #subprocess.Popen(["./test-scripts-test-command.sh", str(hostname), str(port), str(id)], stdout=out, stderr=subprocess.STDOUT)

           # print(out)
            try:
                done = True
            finally:
                self.queue.task_done()


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Invalid arguements\nUsage: python run_test.py <instances> <runtime{fc, runc, runsc-kvm, runsc-ptrace, host}> <test_name in{net, cpu, read, write, mem, mem_unmap}>")
        sys.exit()

    instances = int(sys.argv[1])
    runtime = str(sys.argv[2])
    test_name = str(sys.argv[3])
    output_file = runtime +"_"+ test_name + ".out"
    q = Queue(maxsize=0)

    f = open(output_file, "a+")
    f.write("\n"+str(instances)+ " instance(s)\n")
    f.close()

    #print(threads)
    for i in range(instances):
        worker = Worker(q)
        worker.daemon = True  # setting threads as "daemon" allows main program to
        # exit eventually even if these dont finish
        # correctly.
        worker.start()
        #threads.append(worker)

    count = 0
    for i in range(instances):
        q.put((count, runtime, test_name, output_file))
        count = count + 1

    #wait until the queue has been processed
    q.join()
   
  # for worker in threads:
    #    worker.join()

    logging.info('Done!')
