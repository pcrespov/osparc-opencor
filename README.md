# osparc-opencor

Basic demo of a [hsorby/opencor-python] service for osparc 

This repo contains the code that wraps  [hsorby/opencor-python] to run in [osparc-simcore]. 
- Github repo of base image is [hsorby/docker_opencor_run_model]
- Docker images in [hsorby/opencor-python]


<!-- TOC_BEGIN -->
<!-- Automaticaly produced by tools/auto-doc/create-toc.py on 2020-08-17T14:06 -->
## Available services [1]
|           name            |                  description                  |      type       |  latest version  |                  identifier                  |
|---------------------------|-----------------------------------------------|-----------------|------------------|----------------------------------------------|
|  [osparc-opencor](./src)  |  OpenCOR service for osparc [ISAN-2019 Demo]  |  computational  |  0.3.0           |  [simcore/services/comp/osparc-opencor:0.3.0](https://hub.docker.com/r/itisfoundation/osparc-opencor)  |

 Updated on 2020-08-17T14:06
<!-- TOC_END -->




## Usage

Typical workflow

```console
make build
make test
```

More details
```console
$ make help

build                Builds all service images.
up                   starts services.
down                 stops services.
integration-test     runs integration tests [w/ fail fast] (needs built container)
test                 run all tests
pull                 pull latest service version if available
info                 Displays some parameters of makefile environments
clean                Cleans all unversioned files in project
toc                  Updates README.txt with a ToC of all services
```

[hsorby/opencor-python]:https://hub.docker.com/r/hsorby/opencor-python/tags
[hsorby/docker_opencor_run_model]:https://github.com/hsorby/docker_opencor_run_model

[osparc-simcore]:https://github.com/ITISFoundation/osparc-simcore

