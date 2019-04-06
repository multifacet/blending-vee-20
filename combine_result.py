import glob
import os
import sys

files = glob.glob( '*.txt' )
count = 1
with open( sys.argv[1], 'w' ) as result:
    for file in files:
    	result.write("\n")
       # for lines in open( file, 'r' ):
        f_read = open(file , 'r')
        line = f_read.readlines()[-1]
        result.write( line)

        os.system("rm " + str(file))
        count = count + 1        
