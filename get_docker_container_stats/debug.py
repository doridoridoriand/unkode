import docker
import pdb
import pprint

NANOCPUS_SCALE = 1000000000
client = docker.from_env()

def pretty_print(obj):
    pprint.pprint(obj)

def containers():
    return client.containers.list()

def container_attr(container_id):
    return client.containers.get(container_id)

def container_status(container, stream=False):
    return container.stats(stream=stream)

if __name__ == '__main__':
    containers = containers()
    container = container_attr(containers[0].id)
    #pdb.set_trace()
    container_status = container_status(container)
    total_cpu_usage = container_status['cpu_stats']['cpu_usage']['usage_in_usermode']
    system_cpu_usage = container_status['cpu_stats']['system_cpu_usage']
    print(container_status['name'])
    print("======================")
    print(float(total_cpu_usage) / float(system_cpu_usage) * 100)
    print("======================")
    pretty_print(container_status['cpu_stats'])
