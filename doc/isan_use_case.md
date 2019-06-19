# MAP-Core - SIM-Core use case for ISAN2019

## Preamble
Below some parts taken from ``Proposal for connecting MAP-Core and SIM-Core from PJH 12-May-2019`` relevant to SIM-Core side.

To explore possible interaction between the MAP-Core and SIM-Core projects we propose a pilot
project for ISAN2019 in which a user of the SPARC web portal could choose a CellML model via the
MAP-Core flatmap GUI and set some relevant input(s) for performing a simulation. The model and
simulation description (SED-ML) and control script (Python) would be retrieved from the Physiome
Model Repository (PMR). 

- This package would be runnable on oSPARC using a MAP-Core provided OpenCOR+Python Docker container
- The computational results from the solution of these model equations would be displayed directly on oSPARC and also returned for display on the MAP-Core portal.

After some interaction of the user with the flat-map in the MAP-Core portal:

1. The selected model together with the user-defined level sympathetic drive **is sent to the SIM-Core o2S2PARC platform for simulation**. Note:
   1. The selected model will be defined as a URL to the model and simulation description in PMR (i.e. SED-ML).
   2. The level of sympathetic drive will be parameter values that get set in the model prior to simulation.
   3. These input parameters are used in a defined workflow on oSPARC which makes use of a MAP-Core supplied OpenCOR+Python Docker container.
   4. The workflow on oSPARC results in some relevant simulation results being presented to the user.
   5. If the user still has the Data Portal open in the same place then the simulation results could also show up on the portal flatmap viewer, i.e., the action potential is plotted.
2. The computational results are returned and a cardiac myocyte action potential is displayed, for that sympathetic drive input setting, on the MAP-Core portal.
3. The user chooses another sympathetic drive input setting to repeat the procedure. __What happens then? does it re-use the tabs or new ones?__


## Proposal for Platforms interaction

We propose a **Request/Redirect/Notify** interaction pattern between MAP-core and SIM-core. 

1. MAP-core **requests** [osparc.io] to execute a predefined *parametrized template study* specially prepared for ISAN2019
   1. Request points to a template study and passes the parametrization with key-values as part of the query, e.g. ``GET https://osparc.io/study/{template_id}?param_key=param_value&...`` 
   2. The request parameters are used to:
      1. Pass settings to the osparc-opencor service (e.g. ``stimulation_period_secs``)
      2. Set a webhook to notify completion of execution
   3. For instance, the MAP-core web can show a link to open simcore
    ```bash
    <a href="https://osparc.io/study/template-123456123456?simulation_period_secs=1000&webhook_done=https://opencor.org/notifications?simulation_id=123456">Run in osparc.io</a>
    ```
   4. When user presses this link a new tab opens with [osparc.io]
2. simcore creates a study from the template and applies the parametrization using the provided values. Then it **redirects** to osparc.io and  displays the selected study open and ready to run in the simcore front-end. At this point, the user can run the study and visualize the results interactively.
3. If a webhook url to a callback service is provided in the initial request, simcore will **notify** it when the osparc-opencor service completed execution. The notification request transmits also information of the execution as the exit code and a pre-signed download link for the results. An example of this notification triggered by simcore to the webhook set above would be
    ```bash
    curl --request POST \
    --url 'https://opencor.org/notifications?simulation_id=123456' \
    --header 'Content-Type: application/json' \
    --data '{\n"dowload_link": "https://osparc.io/outbox/123456789/membrain-potential.json"\n"status_code": 0\n}'
    ```
    Using this mechanism, allows MAP-Core to retrieve the results and further process/visualize them in the MAP-Core portal. 


## ISAN 2019 opencor's parametrized template study 

A [parametrized template study](doc/isan_use_case.md) is published for the ISAN2019 demo.
  - This study contains a simple workflow consisting in a osparc-opencor service connected to a jupyter notebook
  - Parameters bound to the osparc-opencor service
    - ``stimulation_period_secs``: float 
    - ... (any other parameters in the future)
  - Study parameters
    - ``webhook_done``: URL webhook to notify execution completed. It is responsibility of the caller to pass the correct endpoint. 

#### ospacr-opencor service in catalog
![image.png](https://images.zenhubusercontent.com/5caef818ecad11531cc41364/5410bb94-38e0-4578-a0e9-1af5cd032ca4)

#### pipeline for ISAN2019 parametrized template study
![image.png](https://images.zenhubusercontent.com/5caef818ecad11531cc41364/e650de33-7b09-4dc0-8260-ede83858463d)

#### Detail of a parameterized input 
TEMPLATE studies can parametrize some of the settings using ``{{ .. }}`` expression (as in [jinja2](http://jinja.pocoo.org/docs/2.10/templates/#expressions) )

![image.png](https://images.zenhubusercontent.com/5caef818ecad11531cc41364/409b43bd-0e1e-4cc2-8740-a125c85d013e)

---

## Glossary

#### osparc
The SIM-Core o2S2PARC platform 

#### osparc front-end
A rich internet application (RIA) served at https://osparc.io

#### osparc-opencor service
The OpenCOR+Python provided by MAP-Core and integrated as a service in [osparc.io]. 
This integration is version-controlled in [ITISFoundation/osparc-opencor](https://github.com/ITISFoundation/osparc-opencor) github repository

#### [parametrized] [template] study
The main document or project in [osparc.io] is denoted a study. It can be plublished as a (parametrized) template which is accessible to all users. [osparc.io] provides an entry-point to request a copy of this template for a user. If the template is parametrized, the copy will replace these parameters in the user's copy.




[osparc.io]:https://osparc.io
[osparc-opencor]:https://github.com/ITISFoundation/osparc-opencor
