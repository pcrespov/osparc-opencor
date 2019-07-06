""" Validates base image without any wrappers

"""
import json
import re

import docker
import pytest

@pytest.fixture
def base_image(repo_dir):
    with open(repo_dir / "src/Dockerfile") as fh:
        for line in fh:
            m = re.match(r'FROM ([\w/\-:\.]+)', line)
            if m:
                return m.group(1)
    raise ValueError(f"Cannot find base-image in {repo_dir}")

@pytest.fixture
def golden_reference(repo_dir):
    with open(repo_dir / "validation/input/input.json") as fh:
        _input = json.load(fh)
    with open(repo_dir / "validation/output/membrain-potential.json") as fh:
        output = json.load(fh)
    
    return _input, output




def test_base_runs(base_image):
    """ Runs command documented in
         https://github.com/hsorby/docker_opencor_run_model
    """    
    client = docker.from_env()
    
    output = client.containers.run(base_image, 
        command= '1000.0', 
        stdout=True, stderr=False)

    result = json.loads(output)
    assert 'membrane' in result


def test_validate_results(base_image, golden_reference):
    _input, expected = golden_reference
    
    client = docker.from_env()
    output = client.containers.run(base_image, 
        command= str( _input["stimulation_period"] ), 
        stdout=True, stderr=False)

    result = json.loads(output)    
    assert result == expected