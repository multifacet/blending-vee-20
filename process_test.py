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
            id, cmd, output_file, round_no = self.queue.get()
            print("id", id)
            #print('\n')
            hostname = "128.110.154.173"
            port = 5201 + id
            with open(output_file, "wb", 0) as out:
               # subprocess.Popen(["./process-command.sh", str(id), str(hostname), str(port)], stdout=out, stderr=subprocess.STDOUT)
                subprocess.Popen(["./process-command.sh", str(id), str(round_no)], stdout=out, stderr=subprocess.STDOUT)
           # print(out)
            try:
                done = True
            finally:
                self.queue.task_done()

if __name__ == '__main__':
    threads = []
    output_file = "process-test"
    command =""

    q = Queue(maxsize=0)

    
    #set the total thread number
    total_thread = int(sys.argv[1])  


    for i in range(total_thread):
        threads.append(command)

    for i in range(total_thread):
        worker = Worker(q)
        worker.daemon = True
        worker.start()
        #threads.append(worker)

    count = 0
    for cmd in threads:
        q.put((count, cmd, output_file + str(count) + ".txt", 0))
        count = count +1

    q.join()
    logging.info('Done!')

