from __future__ import print_function
import os
import sys
import subprocess
import threading
import logging
from Queue import Queue
from threading import Thread
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
            id, cmd, output_file = self.queue.get()
            hostname = "128.110.154.173"
            port = 5201 + id
            #print(" command", cmd)
            #print('\n')
            #with open(output_file, "wb", 0) as out:
            print("hello")
           # with open(output_file, "wb", 0) as out:
            #    subprocess.Popen(["./gVisor-test-command.sh", str(id)], stdout=out, stderr=subprocess.STDOUT)
            #cpu/fio
            output = subprocess.call(["./gVisor-test-command.sh",str(id)])
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
    threads = []
    #command = "ls"
    command = "docker run --rm -v /root/Secure-Serverless/docker/task:/var/task lambci/lambda:python2.7 io_lambda_function.lambda_handler"
    output_file = "gvisor-test"
    q = Queue(maxsize=0)
    #set the total thread number
    total_thread = int(sys.argv[1])

    for i in range(total_thread):
        threads.append(command)

    #print(threads)
    for i in range(total_thread):
        worker = Worker(q)
        worker.daemon = True  # setting threads as "daemon" allows main program to
        # exit eventually even if these dont finish
        # correctly.
        worker.start()
        #threads.append(worker)

    count = 0
    for cmd in threads:
        q.put((count, cmd, output_file + str(count) + ".txt"))
        count = count +1

    #for i in range(total_thread):


    #wait until the queue has been processed
    q.join()
   
   # for worker in threads:
    #    worker.join()

    logging.info('Done!')
