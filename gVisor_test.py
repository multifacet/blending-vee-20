from __future__ import print_function
import os
import sys
import subprocess
import threading
import logging
from Queue import Queue
from threading import Thread


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
            print(" command", cmd)
            #print('\n')
            with open(output_file, "wb", 0) as out:
                subprocess.Popen(["./gVisor-test-command.sh"], stdout=out, stderr=subprocess.STDOUT)
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
    total_thread = 2

    for i in range(total_thread):
        threads.append(command)

    print(threads)
    for i in range(total_thread):
        worker = Worker(q)
        worker.daemon = True  # setting threads as "daemon" allows main program to
        # exit eventually even if these dont finish
        # correctly.
        worker.start()
        #threads.append(worker)

    count = 0
    for cmd in threads:
        q.put((count, cmd, output_file + str(count) + ".log"))
        count = count +1

    #for i in range(total_thread):


    #wait until the queue has been processed
    q.join()
   # for worker in threads:
    #    worker.join()

    logging.info('Done!')
