#!/usr/bin/env python
# coding: UTF-8

import docker
import argparse
import pdb
import pprint

NANOCPUS_SCALE = 1000000000
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

def all_cpu_usage(metrix):
    """
    @param  Type: list, Param: metrix, Description: cpu metrix list
    @return Type: float
    """
    usage = [obj['cpu_percent'] for obj in metrix]
    return sum(usage) / len(usage)

def output(content):
    f = open(arguments.output, 'w')
    f.write(str(content))

def cpu_usage(metrix, container_number):
    """
    @param  Type: list,    Param: metrix, Description: cpu metrix list
    @param  Type: Integer, Param: metrix, Description: container number
    @return Type: float
    """
    return metrix[container_number]['cpu_percent']


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Show CPU usage of docker container(s).')
    parser.add_argument('-a', '--all',
                        action = 'store_true',
                        help = 'show Average out all containers CPU utilization.')
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
        container        = container_attr(container.id)
        container_information = container_status(container)

        container_name      = container_information['name']
        total_cpu_usage     = container_information['cpu_stats']['cpu_usage']['usage_in_usermode']
        pretotal_cpu_usage  = container_information['precpu_stats']['cpu_usage']['usage_in_usermode']
        online_cpus         = container_information['cpu_stats']['online_cpus']
        delta_cpu_usage     = total_cpu_usage - pretotal_cpu_usage
        cpu_percent         = float(delta_cpu_usage) / float(NANOCPUS_SCALE) * 100
        metrix.append({'container_name':     container_name,
         'total_cpu_usage':    total_cpu_usage,
         'pretotal_cpu_usage': pretotal_cpu_usage,
         'delta_cpu_usage':    delta_cpu_usage,
         'cpu_percent':        cpu_percent})

    if arguments.all == True and arguments.output == None:
        print(all_cpu_usage(metrix))

    if arguments.all == True and arguments.output != None:
        output(all_cpu_usage(metrix))

    if arguments.number != None and arguments.output == None:
        print(cpu_usage(metrix, arguments.number))

    if arguments.number != None and arguments.output != None:
        output(cpu_usage(metrix, arguments.number))
