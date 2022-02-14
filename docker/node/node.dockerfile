FROM node:14

WORKDIR /app

RUN npm config set strict-ssl false \
    && yarn config set "strict-ssl" false
