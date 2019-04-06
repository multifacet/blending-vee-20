import glob
import os
import sys

files = glob.glob( '*.txt' )
count = 1
with open( sys.argv[1], 'w' ) as result:
    for file in files:
    	result.write("\n==========Thread" + str(count)+"========")
        for line in open( file, 'r' ):
            result.write( line )

        os.system("rm " + str(file))
        count = count + 1 
