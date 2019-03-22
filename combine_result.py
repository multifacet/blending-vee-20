import glob
import os


files = glob.glob( '*.txt' )
count = 1
with open( 'result.log', 'w' ) as result:
    for file in files:
    	result.write("==========Thread" + str(count)+"========")
        for line in open( file, 'r' ):
            result.write( line )

    os.system("rm " + str(file))
    count = count + 1        