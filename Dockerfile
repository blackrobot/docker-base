# damon/base
#
# This sets up the base Ubuntu machine. It sets the locale, upgrades Ubuntu,
# and installs some necessary packages, including ruby2.1 from the Brightbox
# ppa, and nodejs from Chris Lea's ppa.

FROM ubuntu:precise

# Turn off front-end for package installs
ENV DEBIAN_FRONTEND noninteractive

# Update, upgrade, and set the locale
ADD sources.list /etc/apt/sources.list
RUN apt-get update -qq && \
    apt-get upgrade -qqy && \
    apt-get install -qqy --no-install-recommends language-pack-en && \
    locale-gen 'en_US.UTF-8' && \
    dpkg-reconfigure locales

# Fix some issues with APT packages.
# See https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl

# Required packages
RUN apt-get install -qqy build-essential curl git python-software-properties

# Add the Brightbox PPA, and the nodejs PPA, then install ruby and nodejs
RUN add-apt-repository -y ppa:brightbox/ruby-ng && \
    add-apt-repository -y ppa:chris-lea/node.js && \
    apt-get update -qq && \
    apt-get install -qqy nodejs ruby2.1 ruby2.1-dev
