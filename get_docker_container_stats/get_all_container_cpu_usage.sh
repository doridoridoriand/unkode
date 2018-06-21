#!/bin/bash

numberOfContainer=`docker ps -q | wc -l`;

for ((i = 0; i < $numberOfContainer; i++)) {
  /usr/bin/python ./total_cpu_usage.py -n $i -o cpu_usage_$i
}
