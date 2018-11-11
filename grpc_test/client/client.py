import os
import sys
import yaml
import grpc
import argparse

sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'lib'))
import test_pb2
import test_pb2_grpc

import pdb

config = yaml.load(open(os.path.join(os.path.dirname(__file__), '..', 'config', 'client.yml')))['endpoint']

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'GRPC client for test')
    parser.add_argument('-u', '--username',
                        action = 'store',
                        nargs = None,
                        const = None,
                        default = None,
                        type = str,
                        choices = None,
                        required = True,
                        help = 'Please input a username.')
    arguments = parser.parse_args()

    with grpc.insecure_channel(':'.join([config['host'], str(config['port'])])) as channel:
        stub = test_pb2_grpc.GreeterStub(channel)
        response = stub.SayHello(test_pb2.HelloRequest(name=arguments.username))

    print(response.message)
