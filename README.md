# Keno Antigen Web Socket API documentation

This is the documentation for the Keno Antigen Web Socket API.

Documentation is run from a Jekyll implementation in a Docker container which should
make it much easier to install.

# install

The Docker container does not need to be built, it can be
downloaded automatically from docker-hub.

However, if you change (for example package.json) then it 
can be built thus.

```bash
$ ./build_docker.sh
```

Then run a shell in the container and run the jekyll server


```bash
$ ./run_docker.sh
root@17d2ed3096e5:/docs# jekyll serve
```

This will expose the jekyll documentation on your local server, port 4000

