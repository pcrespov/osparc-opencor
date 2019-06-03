FROM hsorby/opencor-python:0.1.0 as base
#
#  USAGE:
#     cd services/osparc-opencor
#     docker build -f Dockerfile -t osparc-opencor:prod --target production ../../
#     docker run osparc-opencor:prod
#

LABEL maintainer=pcrespov

# simcore-user uid=8004(${SC_USER_NAME}) gid=8004(${SC_USER_NAME}) groups=8004(${SC_USER_NAME})
ENV SC_USER_ID 8004
ENV SC_USER_NAME scu
RUN adduser -D -u ${SC_USER_ID} -s /bin/sh -h /home/${SC_USER_NAME} ${SC_USER_NAME}

RUN apk add --no-cache \
      su-exec \
      bash \
      jq

# --------------------------Production stage -------------------
# Final cleanup up to reduce image size and startup setup
# Runs as ${SC_USER_NAME} (non-root user)
#
#  + /home/${SC_USER_NAME}     $HOME = WORKDIR
#    + osparc-opencor [${SC_USER_NAME}:${SC_USER_NAME}]
#    + docker [${SC_USER_NAME}:${SC_USER_NAME}]
#    + service.cli [${SC_USER_NAME}:${SC_USER_NAME}]
#
FROM base as production

ENV SC_BUILD_TARGET production
ENV SC_BOOT_MODE production

ENV INPUT_FOLDER="/input" \
    OUTPUT_FOLDER="/output" \
    LOG_FOLDER="/log"


WORKDIR /home/${SC_USER_NAME}


COPY docker/*.sh docker/
RUN chmod +x docker/*.sh &&\
      chown ${SC_USER_NAME}:${SC_USER_NAME} docker/*.sh


COPY service.cli/ service.cli/
RUN chmod +x service.cli/* &&\
      chown ${SC_USER_NAME}:${SC_USER_NAME} service.cli/*
# necessary to be able to call run directly without sh in front
ENV PATH="/home/${SC_USER_NAME}/service.cli:${PATH}"

# ------------------------------------------------------------------------------------
#TODO:
# uncomment and provide a healtchecker if possible
# HEALTHCHECK --interval=30s \
#             --timeout=120s \
#             --start-period=30s \
#             --retries=3 \
#             CMD ["healthchecker app"]
# ------------------------------------------------------------------------------------

ENTRYPOINT [ "/bin/sh", "docker/entrypoint.sh" ]
CMD ["/bin/sh", "docker/boot.sh"]
