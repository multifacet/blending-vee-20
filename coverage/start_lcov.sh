#genrate html and info files
mkdir $1
lcov --capture --rc lcov_branch_coverage=1 --output-file $1.info
genhtml --branch-coverage $1.info --output-directory $1


#parse the info file and get the gzip file
node parse.js $1.info $1.json
gzip $1.jsons