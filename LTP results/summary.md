## LTP Results: 

The Linux Test Project (LTP) testsuie consists of tools for testing the Linux kernel and related features. 
We ran the test cases under the syscall suite (defined under testcases/kernel/syscalls). Not all tests were 
running across each platform. The tests that were skipped in in the *skip_tes_new* file. We had to skip few tests 
because not all the were running across each and to make the tests uniform. *runsc* was not able to excute most of them 
as it does not support all the *sycalls*. So we ran a subset of tests from the suite present in LTP. runsc is taken as the baseline
as it ran the minimum from the test suite.

## Observations:
* terminated tests in the results are that of skip tests(termination ID 32)
* Network coverage between runc and runsc was not high which is different from what we observed
in the microbenchmarks. Maybe testing system calls, more than the netwrok transport. 
* Hit rate is not as uniform as we obserevd with the microbenchmarks which could be 
due to no uniform stressing on the sub-systems
* Suite takes different time to run on different platform, so substracting background
noise is a challenge
* Run background for 1 or 2 hours and find the rate 
* Overall coverage is substantially low in the LTP results.
* Host overall for net is more than LXC.
* LXC is doing a lot more *mm*
* Look at code level differences rather than the code overall coverage
* Fine grain data, invocation differences=>future work



