# Keno Antigen Web Socket API Documentation

This is the web site and documentation for Keno Antigen Web Socket API.

The site is run from a Hugo implementation in a Docker container.

# install

The Docker container does not need to be built, it can be
downloaded automatically from docker-hub.

However if you make changes to the build process then it can be
rebuilt thus.

```bash
$ ./build_docker.sh
```

Then run a shell in the container and run the hugo server


```bash
$ ./run_docker.sh
root@17d2ed3096e5:/docs# hugo server -w --bind=0.0.0.0 -b http://kenoantigen.com
```

This will expose the API Documentaion on your local server, port 4000

