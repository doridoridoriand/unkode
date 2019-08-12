# UUID API

# Dependencies
- Ruby 2.6.3
- Docker >= 18.6


# Execute at local (Ruby)
## Installation
```
$ gem install bundler
$ bundle install
```

## Execute (Ruby)
```
$ unicorn -c unicorn.rb
e.g. execute in develop environment
$ unicorn -c unicorn.rb --env development
```

# Execute with docker (Ruby)
## docker build
```
$ docker build -t uuid-api-ruby ./ruby
```

## docker container execution
```
$ docker run -it uuid-api-ruby
```

If you not want to build container at local environment, you can pull the image from dockerhub.

```
$ docker pull doridoridoriand/uuid-api
$ docker run -p 3000:3000 uuid-api:0.0.1
```

# Deploy in Kubernetes
```
$ kubectl create namespace doridoridoriand
$ kubectl apply -f uuid-replicaset.yml
```

Check pods
```
$ kubectl get pods --namespace doridoridoriand
```
