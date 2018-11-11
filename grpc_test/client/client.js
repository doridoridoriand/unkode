const grpc = require('grpc');
const yaml = require('js-yaml');
const fs   = require('fs');

const protoLoader = require('@grpc/proto-loader');

const config_filepath = [__dirname, '..', 'config', 'client.yml'].join('/');
const config = yaml.safeLoad(fs.readFileSync(config_filepath, 'utf8'))['endpoint'];

const proto_path = [__dirname, '..', 'test.proto'].join('/');
const packageDefinition = protoLoader.loadSync(
  proto_path,
  {keepCase: true, longs: String, enums: String, defaults: true, oneof: true}
);

const test_proto = grpc.loadPackageDefinition(packageDefinition).helloworld;

debugger;
