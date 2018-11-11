const grpc = require('grpc');
const yaml = require('js-yaml');
const fs   = require('fs');
const argv = require('argv');

const protoLoader = require('@grpc/proto-loader');

argv.option({
  name:        'username',
  short:       'u',
  type:        'string',
  description: 'Please input some username.',
  example:     '--username=doridoridoriand or -s doridoridoriand'
});

const arguments = argv.run();

if (!arguments.options.username) { console.error('NoUsernameDetectedError'); process.exit(1); }

const config_filepath = [__dirname, '..', 'config', 'client.yml'].join('/');
const config = yaml.safeLoad(fs.readFileSync(config_filepath, 'utf8'))['endpoint'];

const proto_path = [__dirname, '..', 'test.proto'].join('/');
const packageDefinition = protoLoader.loadSync(
  proto_path,
  {keepCase: true, longs: String, enums: String, defaults: true, oneof: true}
);

const test_proto = grpc.loadPackageDefinition(packageDefinition).helloworld;
const client = new test_proto.Greeter([config['host'], config['port']].join(':'),
                                      grpc.credentials.createInsecure());

client.sayHello({name: arguments.options.username}, function(err, response) {
  console.log(response.message);
});

