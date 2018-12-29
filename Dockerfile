# Dockerfile
#
# Project: AutoArchive Docker image
# License: GNU GPLv3
#
# Copyright (C) 2015 - 2018 Robert Cernansky

# Dockerfile for AutoArchive Docker image.



FROM python:slim

MAINTAINER openhs
LABEL version="0.0.3" \
      description="Simple backup tool Docker image."



RUN pip3 install autoarchive

RUN mkdir /etc/aa && \
    /bin/echo -e \
      "[General]\n\
       archive-specs-dir = /opt/aa/archive_specs\n\
       user-config-dir = /opt/aa/user_config_dir" >> /etc/aa/aa.conf && \
    mkdir -p /opt/aa/user_config_dir/storage

COPY ./backup.aa /opt/aa/archive_specs/
COPY ./backup-incremental.aa /opt/aa/archive_specs/

VOLUME /opt/aa/user_config_dir

WORKDIR /opt/aa/backup

ENTRYPOINT ["aa"]
