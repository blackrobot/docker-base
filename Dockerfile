# damon/base
#
# This sets up the base Ubuntu machine. It sets the locale, upgrades Ubuntu,
# and installs some necessary packages, including ruby2.1 from the Brightbox
# ppa, and nodejs from Chris Lea's ppa.

FROM ubuntu:precise

# Update, then set the locale
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update -qq && \
    locale-gen en_US.UTF-8 && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -qq

# Fix some issues with APT packages.
# See https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl

# Required packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -qq build-essential curl git python-software-properties

# Add the Brightbox PPA, and the nodejs PPA, then install ruby and nodejs
RUN add-apt-repository -y ppa:brightbox/ruby-ng && \
    add-apt-repository -y ppa:chris-lea/node.js && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq nodejs ruby2.1 ruby2.1-dev

# Default to bash
CMD ["/bin/bash"]
