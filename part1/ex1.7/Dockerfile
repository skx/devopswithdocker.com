FROM ubuntu:16.04 

WORKDIR /mydir
RUN apt-get update && apt-get install -y curl

CMD echo "Input website:"; read website; echo "Searching.."; sleep 1; curl http://$website;
