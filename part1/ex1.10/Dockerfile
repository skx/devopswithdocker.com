FROM ubuntu:16.04

WORKDIR /webapp

# install dependencies
RUN apt-get update && apt-get install -y curl git-core nodejs npm

#
# Check the installation of node/npm
#
# NOTE: nodejs installs binary as "nodejs" not "node".
#
RUN nodejs -v
RUN npm -v

# Install the webapp.
RUN git clone https://github.com/docker-hy/frontend-example-docker.git

# Setup depedencies
RUN cd frontend-example-docker && npm install

# Expose the port
EXPOSE 5000

# When container is started start node
CMD cd frontend-example-docker && npm start
