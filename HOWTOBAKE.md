# osparc-opencor - How to Bake your Cookie

OpenCOR service for osparc

## Development

1. The source code shall be copied to the [src](osparc-opencor/src/osparc-opencor) folder.
2. The [Dockerfile](osparc-opencor/src/Dockerfile) shall be modified to compile the source code.
3. The [labels](osparc-opencor/docker/labels) json files shall be modified to at least accomodate with the expected inputs/outputs of the service.
4. The [execute](osparc-opencor/service.cli/execute) bash script shall be modified to run the service using the expected inputs and retrieve the expected outputs and log.
5. The test input/output/log shall be copied to [validation](osparc-opencor/validation).
6. The service docker image may be built and tested using:

``` console
make .venv
source .venv/bin/activate

(.venv)$ make build
(.venv)$ make unit-test
(.venv)$ make integration-test
```

## Usage

Default usage will build the service inside a docker container and then run the service using the validation data as input by default.
Results will be stored in osparc-opencor/tmp/output and logs in osparc-opencor/tmp/log.

```console
make .venv
source .venv/bin/activate

(.venv)$ make build
(.venv)$ make up
```

## CI/CD Integration

### Gitlab

add the following in your __gitlab-ci.yml__ file:

```yaml
include:
  - local: '/services/osparc-opencor/CI/gitlab-ci.yml'
```
