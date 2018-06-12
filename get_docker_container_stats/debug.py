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
    total_cpu_usage     = container_status['cpu_stats']['cpu_usage']['usage_in_usermode']
    pretotal_cpu_usage  = container_status['precpu_stats']['cpu_usage']['usage_in_usermode']
    system_cpu_usage    = container_status['cpu_stats']['system_cpu_usage']
    presystem_cpu_usage = container_status['precpu_stats']['system_cpu_usage']
    print(container_status['name'])
    print("======================")
    print(float(total_cpu_usage) / float(system_cpu_usage) * 100)
    print("======================")
    pretty_print(container_status['cpu_stats'])
    print("======================")
    pretty_print(container_status['precpu_stats'])

    delta_total_usage = (total_cpu_usage - pretotal_cpu_usage)
    delta_system_usage = (system_cpu_usage - presystem_cpu_usage)

    cpu_percent = float(delta_total_usage) / float(NANOCPUS_SCALE) * 100
    system_cpu_percent = float(delta_system_usage) / float(NANOCPUS_SCALE) * 100
    print("======================")
    print(delta_total_usage)
    print("======================")
    print(delta_system_usage)
    print("======================")
    print(container_status['cpu_stats']['online_cpus'])
    print("======================")
    print(str(cpu_percent) + '%')
    print("======================")
    # Total available cpu percentage on this machine
    print(str(system_cpu_percent) + '%')
