# osparc-opencor

Basic demo of a OpenCOR service for osparc


## Usage

Typical workflow

```console
make build
make test
```

More details
```console
$ make help
Make targets in osparc-simcore:

build: – Builds all service images.
up, down: – Starts/Stops services.
unit-test – Runs unit tests [w/ fail fast]
integration-test – Runs integration tests [w/ fail fast] (needs built container)
test – Run all tests
push-release, push: – Pushes services to the registry if service not available in registry. push overwrites.
info – Displays some parameters of makefile environments
.venv – Creates a python virtual environment with dev tools (pip, pylint, ...)
clean – Cleans all unversioned files in project
help – Display all callable targets
```

## Dev notes

Implements [osparc-simcore #764](https://github.com/ITISFoundation/osparc-simcore/issues/764)

Had to adapt cc due to some differencies wrt to the service we have been integrating so far

- no source code but instead (Dockerfile [repo](https://github.com/hsorby/docker_opencor_run_model))
- ubuntu instead of alpine
- container prints results to stdout instead of a file


### Limitations

1. version syncs to base image? Our layer has to be minimal!
    - might need a version for the adapter itself (similar to jsonschema)
2. cannot capture errors from opencor [entrypoint.sh](https://github.com/hsorby/docker_opencor_run_model/blob/master/entrypoint.sh). [Reported](https://github.com/hsorby/docker_opencor_run_model/issues/3) to repo.
3. metadata should be more explicit -> metadata folder at level 0
4. schema
5. 


### Upgrading to new verfsion of [hsorby/opencor-python]

```console
(.venv)$ bump2version patch
$ make build
$ make test

## if ok ...
$ git commit -a -m "Upgraded hsorby/opencor-python:0.2.2
```


### TODO

- [ ] add travis CI
- [ ] should validate failures, i.e. how service reacts to wrong inputs (e.g. return codes, etc). In this case, the entrypoit does not react well to failures
- [ ] review workflow with @sanderegg



[hsorby/opencor-python]:https://hub.docker.com/r/hsorby/opencor-python/tags