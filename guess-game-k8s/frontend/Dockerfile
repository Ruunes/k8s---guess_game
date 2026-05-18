FROM node:18 AS build

WORKDIR /app

ARG REACT_APP_BACKEND_URL=/api
ENV REACT_APP_BACKEND_URL=$REACT_APP_BACKEND_URL

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80