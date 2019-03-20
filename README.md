# Secure Serverless


## Set up inststructions

### Prerequistes
* Install iperf3

### Locally running AWS lambda docker images with gVisor
* Install docker from  [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/).
* Setup gVisor using [this](https://github.com/google/gvisor).
* Instructions for testing AWS lambda is given [here](https://aws.amazon.com/about-aws/whats-new/2017/08/introducing-aws-sam-local-a-cli-tool-to-test-aws-lambda-functions-locally/)
* In the framework, the docker images for emulating lambda environment locally is used which is [here](https://github.com/lambci/docker-lambda#run-examples).
* Run the script, by default the script will start one container: 
```bash
sudo ./launch-gvisor-lambda.sh
```

* For starting one than one instance pass it as a command line argument\
example:
 ```bash
sudo ./launch-gvisor-lambda.sh 10
```


### Launching microVMs with firecracker 
* To run multiple microVMs via firecracker, start the *launch-many-firecracker.sh* scripts and pass the number of microVMs you want to start as an arguements.
example:
```bash
sudo ./launch-many-firecracker.sh 10
```
This will spin 10 microVMs.

*Run *cleanup.sh* after you are done.
```bash
sudo ./cleanup.sh
```




