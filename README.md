# Keno Antigen Web Socket API documentation

This is the documentation for the Keno Antigen Web Socket API.

Documentation is run from a Jekyll implementation in a Docker container which should
make it much easier to install.

# install

First build the docker container.

```bash
$ ./build_docker.sh
```

Then run a shell in the container.

```bash
$ ./run_docker.sh
root@17d2ed3096e5:/docs# jekyll serve
```



