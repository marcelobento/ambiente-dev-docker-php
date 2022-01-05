FROM node:14

WORKDIR /app

ENV http_proxy=http://10.1.101.101:8080 \
    https_proxy=http://10.1.101.101:8080

COPY CERTPR.crt /usr/local/share/ca-certificates
RUN update-ca-certificates \
    && npm config set strict-ssl false \
    && yarn config set "strict-ssl" false
