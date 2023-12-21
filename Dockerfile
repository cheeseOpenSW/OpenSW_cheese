FROM node:10-alpine
RUN apt-get update && apt-get -y install build-essential && mkdir –p /app
COPY package*.json /app/
COPY . /app/