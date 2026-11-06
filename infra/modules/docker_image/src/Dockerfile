 # syntax=docker/dockerfile:1
 FROM node:26-alpine
 WORKDIR /app
 COPY . .
 RUN npm install --production
 EXPOSE 3000
 CMD ["node", "index.js"]