import os
import sys
import yaml
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'lib'))

import test_pb2
import test_pb2_grpc

import pdb

config = yaml.load(open(os.path.join(os.path.dirname(__file__), '..', 'config', 'client.yml')))['endpoint']

pdb.set_trace()

if __name__ == '__main__':
    with grpc.insecure_channel() as channel:
        stub = test_pb2_grpc.GreeterStub(channel)
        response = stub.SayHelo(test_pb2.HelloRequest(name=''))

    print(response.message)
