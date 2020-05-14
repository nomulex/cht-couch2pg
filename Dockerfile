# Base Build
FROM node:10.20.1 AS build-couch2pg
WORKDIR /app
COPY . .
RUN npm ci

# Test
FROM build-couch2pg AS test-couch2pg
ARG PG_PASS
ARG COUCH_PASS
ARG COUCH_ADMIN
ARG PG_SVC
ARG COUCH_SVC
ENV TEST_PG_URL="postgres://postgres:${PG_PASS}@${PG_SVC}:5432"
ENV TEST_COUCH_URL="http://${COUCH_ADMIN}:${COUCH_PASS}@${COUCH_SVC}:5984"
WORKDIR /app
RUN npm install -g grunt
RUN grunt test

# Final
FROM build-couch2pg AS medic-couch2pg
WORKDIR /app
RUN rm -rf tests
Entrypoint ["node ."]
