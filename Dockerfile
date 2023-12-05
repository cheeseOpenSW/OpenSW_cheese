FROM node:10-alpine
RUN apt-get update && apt-get -y install build-essential && mkdir –p /app
COPY package*.json /app/
COPY . /app/
WORKDIR /app
RUN npm install
ENV PORT 5000
EXPOSE 5000
CMD ["npm", "start"]
