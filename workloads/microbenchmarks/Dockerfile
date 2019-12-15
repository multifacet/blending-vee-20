FROM gcc:4.9
RUN apt-get update
RUN apt-get install -y iperf3
RUN apt-get install -y sysbench
RUN apt-get install -y iputils-ping
RUN apt-get -y install uuid-dev
RUN apt -y install strace
COPY .. /
