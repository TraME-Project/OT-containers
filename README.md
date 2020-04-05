# Docker Containers for Numerical Optimal Transport

## Getting Started

To get started, install [Docker](https://docs.docker.com/install/) and pull the latest Fedora 31 container:

```{bash}
docker pull fedora:31
```

## Build Containers

The build sequence is as follows.

1. Base container with core libraries:
    ```{bash}
    docker build --tag=monge-base:latest --tag=monge-base:stable -f ./monge-base/monge-base.Dockerfile ./monge-base
    ```
2. Install dependencies for the OT libraries:
    ```{bash}
    docker build --tag=monge-depen:latest --tag=monge-depen:stable -f ./monge-depen/monge-depen.Dockerfile ./monge-depen
    ```
3. Build OT libraries:
    ```{bash}
    docker build --tag=monge-ot-libs:latest --tag=monge-ot-libs:stable -f ./monge-ot-libs/monge-ot-libs.Dockerfile ./monge-ot-libs
    ```

## Running Jupyter Lab

To run the final Docker image in interactive mode with port 8888 open:
```{bash}
docker run -it -p 8888:8888 monge-ot-libs
```

To run Jupyter Lab

```{bash}
cd ~/ot_libs
jupyter lab --ip=0.0.0.0 --allow-root
```

## Misc Docker Commands

* To list your Docker images
    ```{bash}
    docker images
    ```

* To delete an image
    ```{bash}
    docker image rm <Image ID> --force
