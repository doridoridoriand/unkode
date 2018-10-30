# GRPCためした
ひとまずRubyで

インストール
```
$ gem install bundler
$ bundle install
```

proto定義からrubyに合うコードを生成(protoファイルのシンタックスチェックも兼ねてる)
```
$ grpc_tools_ruby_protoc --ruby_out=./lib --grpc_out=./lib test.proto
```
