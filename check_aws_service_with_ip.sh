#!/bin/bash
curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq ".[]" | jq -r ".[].service" | sort -u
