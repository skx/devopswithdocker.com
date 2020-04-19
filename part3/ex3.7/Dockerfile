# https://hub.docker.com/_/golang
FROM golang:1.14.2-buster AS build

# Install git to clone.
RUN apt-get update && apt-get install git-core --yes

# Let us work somewhere
RUN mkdir /app

# Clone
RUN cd /app && git clone https://github.com/skx/httpd.git

# Build
RUN cd /app/httpd && go build .


##
## Now copy into the minimal image
##
FROM debian:buster

WORKDIR /

COPY --from=build /app/httpd/httpd /bin

# Expose the port
EXPOSE 3000

# Create a stub HTML file
RUN mkdir /docs
RUN echo 'Hello skx/httpd' > /docs/index.html

# Add the user
RUN useradd server

# Run
CMD su - server -c "/bin/httpd -host 0.0.0.0 -path /docs"
