# osparc-opencor

Basic demo of a OpenCOR service for osparc


## Usage

**activate python virtual env**
```console
make .venv
source .venv/bin/activate
```

**to build the project and run the project with the validation data as input**
```console
(.venv)$ make build
(.venv)$ make up

```
The run will use the validation data as input by default. Results of the run will be stored in ``osparc-opencor/tmp/output`` and logs in ``osparc-opencor/tmp/log``

**to run the test suites**
```console
(.venv)$ pip install -r tests/requirements.txt
(.venv)$ make unit-test
(.venv)$ make integration-test
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


### TODO

- [ ] add travis CI
- [ ] define communcation
- [ ] should validate failures, i.e. how service reacts to wrong inputs (e.g. return codes, etc). In this case, the entrypoit does not react well to failures
- [ ] review workflow with @sanderegg
