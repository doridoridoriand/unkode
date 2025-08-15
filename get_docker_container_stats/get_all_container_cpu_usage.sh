#!/bin/bash

numberOfContainer=`docker ps -q | wc -l`;
python_path=$(command -v python3) if [ -z "$python_path" ]; then echo "Error: python3 interpreter not found" >&2 exit 1 fi

for ((i = 0; i < $numberOfContainer; i++)) {
  $python_path ./total_cpu_usage.py -n $i -o cpu_usage_$i.json
}
