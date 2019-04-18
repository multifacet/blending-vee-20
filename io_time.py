from __future__ import print_function
import sys
import subprocess
import time


if __name__ == '__main__':

    total_container = int (sys.argv[1])
    i = 0
    for i in range(total_container):
        output_file = "io_time"+str(i)+".log"
        with open(output_file, "wb", 0) as out:
            subprocess.Popen(["./gVisor-test-command.sh"], stdout=out, stderr=subprocess.STDOUT)
        time.sleep(10)
