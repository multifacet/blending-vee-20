mkdir $1
lcov --capture --rc lcov_branch_coverage=1 --output-file $1.info
genhtml --branch-coverage $1.info --output-directory $1