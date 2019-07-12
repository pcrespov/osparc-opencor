# osparc-opencor

Basic demo of a [hsorby/opencor-python] service for osparc 



<!-- TOC_BEGIN -->
<!-- Automaticaly produced by tools/auto-doc/create-toc.py on 2019-07-12T19:33 -->
## Available services [1]
|           name            |                  description                  |      type       |  latest version  |                  identifier                  |
|---------------------------|-----------------------------------------------|-----------------|------------------|----------------------------------------------|
|  [osparc-opencor](./src)  |  OpenCOR service for osparc [ISAN-2019 Demo]  |  computational  |  0.2.3           |  simcore/services/comp/osparc-opencor:0.2.3  |

 Updated on 2019-07-12T19:33
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


