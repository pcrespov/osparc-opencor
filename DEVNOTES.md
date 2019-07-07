# Dev notes

Implements [osparc-simcore #764](https://github.com/ITISFoundation/osparc-simcore/issues/764)

Had to adapt cc due to some differencies wrt to the service we have been integrating so far

- no source code but instead (Dockerfile [repo](https://github.com/hsorby/docker_opencor_run_model))
- ubuntu instead of alpine
- container prints results to stdout instead of a file


## Limitations

1. version syncs to base image? Our layer has to be minimal!
    - might need a version for the adapter itself (similar to jsonschema)
2. cannot capture errors from opencor [entrypoint.sh](https://github.com/hsorby/docker_opencor_run_model/blob/master/entrypoint.sh). [Reported](https://github.com/hsorby/docker_opencor_run_model/issues/3) to repo.
3. metadata should be more explicit -> metadata folder at level 0
4. schema

## Upgrading to new version of [hsorby/opencor-python]

```console
(.venv)$ bump2version patch
$ make build
$ make test

## if ok ...
$ git commit -a -m "Upgraded hsorby/opencor-python:0.2.2
```


## TODO

- [ ] add travis CI
- [ ] should validate failures, i.e. how service reacts to wrong inputs (e.g. return codes, etc). In this case, the entrypoit does not react well to failures
- [ ] review workflow with @sanderegg



[hsorby/opencor-python]:https://hub.docker.com/r/hsorby/opencor-python/tags

