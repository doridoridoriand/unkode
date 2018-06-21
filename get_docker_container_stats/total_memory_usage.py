#!/usr/bin/env python
# coding: UTF-8

import docker
import argparse
import pdb
import pprint

client = docker.from_env()

class ContainerNumberNotDetectedError(Exception):
    def __str__(self):
        return 'Container number is not entered. Entering the container number can not be omitted with the `all` option not selected.'

class TooMuchOptionsAreSelectedError(Exception):
    def __str__(self):
        return '`all` and `number` option can not be used at the same time.'

def pretty_print(obj):
    pprint.pprint(obj)

def container_attr(container_id):
    return client.containers.get(container_id)

def container_status(container, stream=False):
    return container.stats(stream=stream)

def containers():
    """
    @return list
    """
    return client.containers.list()

def all_memory_usage(metrix):
    """
    @param  Type: list, Param: metrix, Description: metrix list
    @return Type: float
    """
    usage = [obj['used_memory_megabytes'] for obj in metrix]
    return sum(usage) / len(usage)

def output(content):
    f = open(arguments.output, 'w')
    f.write(str(content))

def memory_usage(metrix, container_number):
    """
    @param  Type: list,    Param: metrix, Description: metrix list
    @param  Type: Integer, Param: metrix, Description: container number
    @return Type: float
    """
    return metrix[container_number]['used_memory_megabytes']

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Show Memory usage of docker container(s).')
    parser.add_argument('-a', '--all',
                        action = 'store_true',
                        help = 'show Average out all containers Memory utilization.')
    parser.add_argument('-n', '--number',
                        action = 'store',
                        nargs = None,
                        const = None,
                        default = None,
                        type = int,
                        choices = None,
                        help = 'Input container')
    parser.add_argument('-o', '--output',
                        action = 'store',
                        nargs = None,
                        const = None,
                        default = None,
                        type = str,
                        choices = None,
                        help = 'Output container stats to the file.')

    arguments = parser.parse_args()

    if arguments.all == False and arguments.number == None:
        raise ContainerNumberNotDetectedError()

    if arguments.all == True and arguments.number != None:
        raise TooMuchOptionsAreSelectedError()

    containers = containers()
    metrix = []
    for container in containers:
        container             = container_attr(container.id)
        container_information = container_status(container)

        container_name                   = container_information['name']
        available_memory_limit_bytes     = float(container_information['memory_stats']['limit'])
        available_memory_limit_megabytes = float(available_memory_limit_bytes / 1024 / 1024)
        used_memory_bytes                = float(container_information['memory_stats']['usage'])
        used_memory_megabytes            = float(used_memory_bytes / 1024 / 1024)

        metrix.append({
         'container_name':                   container_name,
         'available_memory_limit_bytes':     available_memory_limit_bytes,
         'available_memory_limit_megabytes': available_memory_limit_megabytes,
         'used_memory_bytes':                used_memory_bytes,
         'used_memory_megabytes':            used_memory_megabytes
        })

    if arguments.all == True and arguments.output == None:
        print(all_memory_usage(metrix))

    if arguments.all == True and arguments.output != None:
        output(all_memory_usage(metrix))

    if arguments.number != None and arguments.output == None:
        print(memory_usage(metrix, arguments.number))

    if arguments.number != None and arguments.output != None:
        output(memory_usage(metrix, arguments.number))
