FROM node:latest

RUN mkdir -p /app/src

WORKDIR /app/src

COPY package.json .

RUN npm install

COPY . .

EXPOSE 8081

CMD ["node", "app.js"]

