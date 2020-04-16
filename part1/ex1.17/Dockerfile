FROM debian:stretch

# curl is required to download the binary.
#
# git-core so that `go get ..` works.
#
RUN apt-get update && apt-get install curl git-core -y

# deploy go binaries beneath /opt/go
RUN curl --silent https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz | tar -C /opt -zxf-

# Allow tools to be accessed.
ENV PATH /go/bin:/opt/go/bin:$PATH

# Setup the environment to point to user-go-dir
ENV GOPATH /go

# Work in /go
RUN mkdir -p "/go/src" "/go/bin"
RUN chmod -R 777 /go

# Now it exists
WORKDIR /go
