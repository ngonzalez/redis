#### Build redis image with Docker

```shell
docker buildx prune
```

```shell
docker build . --no-cache -f Dockerfile -t ngonzalez121/redis
```

```shell
docker run --rm -it -p 6379:6379 ngonzalez121/redis
``` 

```shell
docker push ngonzalez121/redis
```
