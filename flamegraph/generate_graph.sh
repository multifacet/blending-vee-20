#!/usr/bin/env bash

perf script | ./stackcollapse-perf.pl | ./flamegraph.pl > $1.svg
