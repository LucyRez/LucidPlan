FROM node:alpine

WORKDIR /usr/messageService

COPY package*.json ./

RUN npm install
COPY . .

EXPOSE 4000

CMD ["node", "messageService.js"]