FROM atlassian/bamboo-agent-base:9.5.2

RUN sed -i -e 's/version < 9.6/version < 9.5/g' -e 's/version >= 9.6/version >= 9.5/g' /opt/atlassian/etc/wrapper.conf.j2

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y \
    && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*
 
RUN ${BAMBOO_USER_HOME}/bamboo-update-capability.sh "system.docker.executable" /usr/bin/docker

COPY entrypoint.sh /entrypoint.sh 

ENTRYPOINT ["/entrypoint.sh", "/pre-launch.sh"]
CMD ["/usr/bin/tini", "--", "/entrypoint.py"]
