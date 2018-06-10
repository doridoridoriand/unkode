import docker
import pdb
import pprint

NANOCPUS_SCALE = 1000000000
client = docker.from_env()

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

if __name__ == '__main__':
    containers = containers()
    useage_in_usermode = []
    for container in containers:
        container        = container_attr(container.id)
        container_status = container_status(container)

        container_name        = container_status['name']
        total_cpu_usage       = container_status['cpu_stats']['cpu_usage']['total_usage']
        cpu_usage_in_usermode = container_status['cpu_stats']['cpu_usage']['usage_in_usermode']
        online_cpus           = container_status['cpu_stats']['online_cpus']
        system_cpu_usage      = container_status['cpu_stats']['system_cpu_usage']

        pdb.set_trace()

        useage_in_usermode.append(container.stats(stream=False)['precpu_stats']['cpu_usage']['usage_in_usermode'])
        pretty_print(container.stats(stream=False))

    print(pretty_print(useage_in_usermode))
