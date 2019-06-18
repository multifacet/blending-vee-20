#launch script in background
./cprobe 1024 > out.txt &
# Get its PID
PID=$!
# Wait for 10 seconds
sleep 10
# Kill it
kill -SIGINT $PID
