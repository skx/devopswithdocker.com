FROM ubuntu:16.04

WORKDIR /webserver

# Install dependencies
RUN apt-get update && apt-get install -y curl git-core

# Install node/npm
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get update && apt-get install -y nodejs

# Check the installation of node/npm
RUN node -v
RUN npm -v

# Install the project.
RUN git clone https://github.com/docker-hy/backend-example-docker.git

# Setup depedencies
RUN cd backend-example-docker && npm install

# Expose the port
EXPOSE 8000

# When container is started start node
CMD cd backend-example-docker && npm start
