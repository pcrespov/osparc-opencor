# hsorby/opencor-python

Demos running CellML model with OpenCOR+Python

- Provided as a docker [image](https://hub.docker.com/r/hsorby/opencor-python)
```cmd
$ docker run -it hsorby/opencor-python
Usage: docker run hsorby/opencor-python <float>
  where <float> is the stimulation period as a decimal number
```
- Prints a json in std-out as
```json
{"membrane": 
    {
        "v": [ -87.0, 48.28257417245303,  ...  ] 
    }
}
```
- See [github repository](https://github.com/hsorby/docker_opencor_run_model.git) with Dockerfile to understand how the underline programs are assembled together

