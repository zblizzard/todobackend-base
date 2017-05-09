FROM ubuntu:trusty
MAINTAINER Zach Blizzard <zachary.blizzard@gmail.com>

# Prevent dpkg errors
ENV TERM=xterm-256color

# Set mirrors to US
RUN sed -i "s/http:\/\/archive./http:\/\/us.archive./g" /etc/apt/sources.list

# Install Python runtime - minimum install withou recommended or suggested extras 
RUN apt-get update && \
	apt-get install -y \
	-o APT::Install-Recommend=false -o APT::Install-Suggests=false \
	python python-virtualenv libpython2.7 python-mysqldb

# Create virtual environment - python will always run in virtual environment
# Upgrade PIP in virtual environment to latest version
RUN virtualenv /appenv && \
	. /appenv/bin/activate && \
	pip install pip --upgrade

# Add entrypoint script for running commands in the virtual env
ADD scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]