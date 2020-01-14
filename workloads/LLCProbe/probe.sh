#launch script in background
./cprobe $2 &
# Get its PID
PID=$!
# Wait for 10 seconds
sleep $1
# Kill it
kill -SIGINT $PID
sleep 2
