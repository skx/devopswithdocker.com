FROM node:alpine AS build

# Workdir
WORKDIR /build

# Expose the port
EXPOSE 8000

# Export the front-end URL
ENV API_URL=http://127.0.0.1/api

# Install dependencies
RUN apk update && apk add git

# Install the project.
RUN git clone https://github.com/docker-hy/frontend-example-docker.git /build/frontend-example-docker

# Setup depedencies, and build static
RUN cd /build/frontend-example-docker && npm install && npm run-script build

# SHOW
RUN ls /build/frontend-example-docker/dist/

#
# Now we have `build` image containing the application in /build/frontend..
#
# Copy the generated files from /build/frontend-example-docker/dist
#
FROM node:alpine

# Use our new workdir with just the copied assets
WORKDIR /app

# Copy our files
COPY --from=build /build/frontend-example-docker/dist/ /app

# Now we need a server.  Sigh
RUN npm install -g serve

# When container is started start node
CMD serve -s -l 8000
