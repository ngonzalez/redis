#### postgresql-redis

```shell
docker build . -f Dockerfile -t redis
```

```shell
docker run --rm -it -p 6379:6379 redis
``` 

```shell
export REDIS_SERVER_IP=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis`
```
