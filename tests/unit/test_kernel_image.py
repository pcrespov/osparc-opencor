""" Validates base image without any wrappers

"""
import itertools
import json
import re

import pytest

import docker


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
        inputs = json.load(fh)
    
    with open(repo_dir / "validation/output/results.json") as fh:
        output = json.load(fh)
    
    return inputs, output




@pytest.mark.parametrize("stimulation_mode,stimulation_level",
    list(itertools.product( (1,2), (0, 0.5, 1.0) ) )
)
def test_kernel_runs(base_image, stimulation_mode, stimulation_level):
    """ Runs command documented in
         https://github.com/hsorby/docker_opencor_run_model


    Usage: docker run hsorby/opencor-python <int> <float>
        where <int> is the stimulation mode as an integer number (1:stellate; 2:vagal).
        where <float> is the stimulation level (0-1) as a decimal number.
    """
    client = docker.from_env()

    output = client.containers.run(base_image, 
        command= f'{stimulation_mode} {stimulation_level}', 
        stdout=True, stderr=False)

    result = json.loads(output)
    assert 'heart_rate' in result
    assert 'membrane' in result
    
    assert result['heart_rate'] > 0
    assert result['membrane']['v']

def test_validate_results(base_image, golden_reference):
    inputs, expected = golden_reference

    client = docker.from_env()
    output = client.containers.run(base_image, 
        command= '{stimulation_mode} {stimulation_level}'.format(**inputs),
        stdout=True, stderr=False)

    result = json.loads(output)
    assert result == expected

@pytest.mark.skip(reason='TODO')
def test_kernel_failure():
    # add a failing condition and ensure it returns non-zero code
    pass
