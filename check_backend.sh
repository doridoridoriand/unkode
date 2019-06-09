#!/bin/bash
dig $1 +short | head -1 | xargs nslookup
