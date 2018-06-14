import docker
import argparse
import pdb
import pprint

NANOCPUS_SCALE = 1000000000
client = docker.from_env()

class ContainerNumberNotDetectedError(Exception):
    def __str__(self):
        return 'Container number is not entered. Entering the container number can not be omitted with the `all` option not selected.'

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

    arguments = parser.parse_args()

    if arguments.all == False and arguments.number == None:
        raise ContainerNumberNotDetectedError()

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

