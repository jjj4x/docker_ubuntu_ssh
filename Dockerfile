# AUTHOR: Maxim Preobrazhensky
# DESCRIPTION: Docker SSH guide refactored (https://docs.docker.com/engine/examples/running_ssh_service/)
# SOURCE: https://github.com/jjj4x/docker_ubuntu_ssh
FROM ubuntu:16.04
LABEL maintainer="max.preobrazhensky@gmail.com"

ARG SSH_USER='greg'
ARG SSH_USER_PASSWORD='123'
ARG SSH_USER_HOME='/home/${SSH_USER}'
ARG SSH_ROOT_PASSWORD='123'

# Never prompt the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=linux \
    ENV_FOR_SSH_EXAMPLE="should be in /etc/profile"

RUN echo -e "****************************************UPDATE****************************************\n" \
    && apt-get update \

    && echo -e "*************************************INSTALL SSHD*************************************\n" \
    && apt-get install -y openssh-server \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && mkdir /var/run/sshd \

    && echo -e "**************************************SETUP ROOT**************************************\n" \
    && echo "root:${SSH_ROOT_PASSWORD}" | chpasswd \

    && echo -e "**************************************SETUP USER**************************************\n" \
    && useradd --create-home --home-dir ${SSH_USER_HOME} ${SSH_USER} \
    && echo "${SSH_USER}:${SSH_USER_PASSWORD}" | chpasswd \

    && echo -e "************************************SSH LOGIN FIX************************************\n" \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \

    && echo -e "********************ANY SSH-VISIBLE ENVs SHOULD BE ADDED BELOW********************\n" \
    && echo 'export ENV_FOR_SSH_EXAMPLE=${ENV_FOR_SSH_EXAMPLE}' >> /etc/profile \

    && echo -e "**************************************CLEANUP**************************************\n" \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
