#!/bin/bash

numberOfContainer=`docker ps -q | wc -l`;
python_path=$(which python3)

for ((i = 0; i < $numberOfContainer; i++)) {
  $python_path ./total_cpu_usage.py -n $i -o cpu_usage_$i.json
}
