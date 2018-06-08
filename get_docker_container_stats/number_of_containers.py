import docker

if __name__ == '__main__':
    client = docker.from_env()
    print len(client.containers.list())
