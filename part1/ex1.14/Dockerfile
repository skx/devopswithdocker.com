# https://hub.docker.com/_/ruby
FROM ruby:2.6.6

# Setup working directory
WORKDIR /app

# Install git to clone.
RUN apt-get update && apt-get install git-core --yes

# Clone
RUN cd /app && git clone https://github.com/docker-hy/rails-example-project.git

# Install dependencies
RUN apt-get update -y && apt-get -y install nodejs

# Get the Ruby dependencies present.
RUN cd /app/rails-example-project && bundle install

# Setup the initial DB
RUN cd /app/rails-example-project && rails db:migrate

ENTRYPOINT ["rails"]
# command represents an argument list for the entrypoint
CMD ["serve"]
