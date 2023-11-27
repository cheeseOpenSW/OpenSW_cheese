FROM ubuntu:20.04
RUN apt-get update && apt-get -y install build-essential && makdir -p /app
COPY . /app/
WORKDIR /app/

