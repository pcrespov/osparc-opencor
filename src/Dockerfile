FROM hsorby/opencor-python:0.1.0 as base

LABEL maintainer=pcrespov

ENV SC_USER_ID 8004
ENV SC_USER_NAME scu

RUN apt-get -qq update && \
    apt-get install -y \
      gosu    \
      jq    &&\
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/sh -u ${SC_USER_ID} -U ${SC_USER_NAME}

# --------------------------Production stage -------------------
FROM base AS production

ENV INPUT_FOLDER "/input"
ENV OUTPUT_FOLDER "/output"
ENV LOG_FOLDER "/log"
ENV PATH "/home/${SC_USER_NAME}/service.cli:${PATH}"

WORKDIR /home/${SC_USER_NAME}

COPY docker/*.sh docker/
RUN chmod +x docker/*.sh &&\
      chown ${SC_USER_NAME}:${SC_USER_NAME} docker/*.sh

COPY service.cli/ service.cli/
RUN chmod +x service.cli/* &&\
      chown ${SC_USER_NAME}:${SC_USER_NAME} service.cli/*


ENTRYPOINT [ "/bin/sh", "docker/entrypoint.sh" ]
CMD ["/bin/sh", "docker/boot.sh"]
