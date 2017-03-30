FROM node:6.9.4

RUN npm install -g gitbook-cli
RUN gitbook install

EXPOSE 4000

CMD ["gitbook"]
