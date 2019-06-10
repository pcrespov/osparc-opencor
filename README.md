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

## Versioning

Do the following to change the version of the dockerized service

```console
# activate python virtual env
make .venv
source .venv/bin/activate

(.venv)$ pip install bumpversion
(.venv)$ bumpversion ARG
```
