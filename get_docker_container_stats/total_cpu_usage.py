import docker
import pdb
import pprint

client = docker.from_env()

def pretty_print(obj):
    pprint.pprint(obj)


def containers():
    """
    @return list
    """
    return client.containers.list()

if __name__ == '__main__':
    containers = containers()
    useage_in_usermode = []
    for container in containers:
        container = client.containers.get(container.id)
        useage_in_usermode.append(container.stats(stream=False)['precpu_stats']['cpu_usage']['usage_in_usermode'])

    print(pretty_print(useage_in_usermode))
