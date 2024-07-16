#### redis-docker

```shell
docker build . -f Dockerfile -t redis --no-cache
```

```shell
docker run --rm -it -p 6379:6379 redis
``` 
