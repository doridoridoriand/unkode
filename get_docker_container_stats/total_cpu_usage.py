import docker
import pdb
import pprint

NANOCPUS_SCALE = 1000000000
client = docker.from_env()

def pretty_print(obj):
    pprint.pprint(obj)

def container_attr(container_id):
    return client.containers.get(container_id)

def container_status(container, stream_mode=False):
    return container.stats(stream=stream_mode)

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

        container_name     = container_status['name']
        total_cpu_usage    = container_status['cpu_stats']['cpu_usage']['total_usage']
        availabe_cpu_usage = container_status['cpu_stats']['cpu_usage']['usage_in_usermode']
        online_cpus        = container_status['cpu_stats']['online_cpus']
        system_cpu_usage   = container_status['cpu_stats']['system_cpu_usage']

        useage_in_usermode.append(container.stats(stream=False)['precpu_stats']['cpu_usage']['usage_in_usermode'])
        pretty_print(container.stats(stream=False))
        pdb.set_trace()

    print(pretty_print(useage_in_usermode))
