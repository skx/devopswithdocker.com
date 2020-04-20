FROM debian:buster

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y git-core

# Install Docker
#  https://docs.docker.com/engine/install/debian/
#
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io && apt-get clean

# Copy our script
COPY builder /app/builder

# Make it available
ENV PATH /app:$PATH

# Setup a default command
ENTRYPOINT ["/app/builder"]
