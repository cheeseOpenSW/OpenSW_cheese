FROM node:18.16.0-alpine
RUN mkdir –p /app
COPY package*.json /app/
COPY . /app/
WORKDIR /app
RUN npm install
ENV PORT 5000
EXPOSE 5000
CMD ["npm", "start"]
