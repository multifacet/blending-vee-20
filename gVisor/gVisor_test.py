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

    def run(self):
        done = False
        while not done:
            if self.queue.empty():
                continue
            id, runtime, test_name, output_file = self.queue.get()

            hostname = ""
            port = 5201
            with open("../config.yml", 'r') as ymlfile:
                cfg = yaml.load(ymlfile, Loader=yaml.FullLoader)

            #print(cfg['net_test'])
            for item, val in cfg['net_test'].items():
                #print(item)
                if item == 'IP':
                    hostname = val

                if item == 'port':
                    port = val + id

            #with open(output_file, "wb", 0) as out:
            #print("hello")
            process = subprocess.Popen(["./gVisor-test-command.sh", str(id), str(test_name),
                                        str(runtime), str(hostname),  str(port)],
                                       stdout=PIPE, stderr=PIPE)
            stdout, stderr = process.communicate()
            print(stdout.decode('utf-8').splitlines())
            stdout, stderr
           # with open(output_file, "wb", 0) as out:
            #    subprocess.Popen(["./gVisor-test-command.sh", str(id)], stdout=out, stderr=subprocess.STDOUT)
            #cpu/fio
            #output = subprocess.call(["./gVisor-test-command.sh",str(id)])
            #print(output)
            #net
            #output= subprocess.call(["./gVisor-test-command.sh", str(hostname), str(port), str(id)])
            #print (output)
            #session = subprocess.Popen(["./gVisor-test-command.sh", str(id)], stdout=PIPE, stderr=PIPE)
                #net
                #subprocess.Popen(["./gVisor-test-command.sh", str(hostname), str(port), str(id)], stdout=out, stderr=subprocess.STDOUT)

           # print(out)
            try:
                done = True
            finally:
                self.queue.task_done()


if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Invalid arguements\nUsage: pyhton run_test.py <instances> <runtime:> <test_name in{net, cpu, read, write, mem, mem_unmap}>")
        sys.exit()

    instances = int(sys.argv[1])
    runtime = str(sys.argv[2])
    test_name = str(sys.argv[3])
    output_file = runtime +"_"+ test_name + ".out"
    q = Queue(maxsize=0)




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

    #logging.info('Done!')
