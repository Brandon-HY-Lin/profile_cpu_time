#!/bin/bash

SAMPLE_TIME=60

sh get_cpu_time.sh > log_0.txt
sleep $SAMPLE_TIME
sh get_cpu_time.sh > log_1.txt                                                  

