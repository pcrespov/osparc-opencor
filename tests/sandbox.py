

from yarl import URL

# User sets up a simulation in MAPCORE website UI
# The selected model will be defined as a URL to the model and simulation description in PMR (i.e. SED-ML).
SIMULATION_ID = "bce098f6-d415-43a3-b461-cd5d232fc415"

# MAPCORE defines an entry point to get notified that results are ready
ready_url = URL("https://opencor.org/notifications/{result_id}".format(result_id=SIMULATION_ID))



# SIMCORE-OSPARC has published a parametrized template study with an opencor service
OPENCORE_TEMPLATE_STUDY_ID = "64ea4bcb-f1fe-411d-afdb-05828c4dccf9"

# This template study is in addition parametrized (can be extended)
# MAPCORE web sets the parameters 
params = {
    # MAP-Core params here
    'simulation_period_secs': 1000,
    #
    # Add more here ....
    #
    # web-hook to notify back that the results are ready
    'done_webhook': str(ready_url)
}


# osparc entrypoint for opencor template
osparc_base_url = URL('https://osparc.io')
run_url = osparc_base_url \
    .with_path('study/{template_id}'.format(template_id=OPENCORE_TEMPLATE_STUDY_ID)) \
    .with_query(**params)

# MAPCORE POST request
# - fire-and-forget
print("POST %s", run_url)

# redirects to osparc.io web
# creates a study out of template and replaces input parameters
# user can interact in osparc.io web
# user runs study
# when osparc-service results are ready, they are automatically stored
# osparc.io sends notification to url passed in ```done_webhook`` parameter
# with a link to a pre-signed link where the notified entity can download and use
presigned_token = "64d8838d-6f53-4911-ad7c-a3ed811790c9"
download_link = osparc_base_url.with_path("outbox/{}".format(presigned_token))

notification_body = {
    'download_link': download_link, 
    'status_code': 0  # code returned by 
}

print("POST {}", ready_url)
