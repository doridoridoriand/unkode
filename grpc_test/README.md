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
$ pip install -r requirements.txt
```

proto定義からpython用のserviceファイルを作成(protoファイルのシンタックスチェックも兼ねている)

```
$ python -m grpc_tools.protoc -I=. --python_out=./lib --grpc_python_out=./lib test.proto
```

## Node
node版はproto定義からダイナミックに必要なserviceファイルを作成できるので、lib配下に関係するクラスを作らなくて良い。<br>
(明示的に生成することも可能)

```
$ npm install
```
