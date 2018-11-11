# GRPCためした

## Ruby
インストール

```
$ gem install bundler
$ bundle install
```

proto定義からrubyに合うコードを生成(protoファイルのシンタックスチェックも兼ねてる)

```
$ grpc_tools_ruby_protoc --ruby_out=./lib --grpc_out=./lib test.proto
```

## Python
pipのバージョンが9.0.1以上じゃないと失敗する

```
$ pip install --upgrade pip
$ pip install grpcio
$ pip install grpcio-tools googleapis-common-protos
```
