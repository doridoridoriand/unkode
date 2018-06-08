import docker
import pdb
import pprint

def pretty_print(obj):
    pprint.pprint(obj)

if __name__ == '__main__':
    client = docker.from_env()
    containers = client.containers.list()
    for containers in containers:
        client.containers.get(client.containers.list()[0].id).attrs
        pdb.set_trace()
