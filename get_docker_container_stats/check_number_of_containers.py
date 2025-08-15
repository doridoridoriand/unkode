#!/usr/bin/env python
# coding: UTF-8

import docker
import argparse
import pdb
import pprint

def pretty_print(obj):
    pprint.pprint(obj)

if __name__ == '__main__':
    client = docker.from_env()
    containers = client.containers.list()
    pdb.set_trace()
