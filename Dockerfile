FROM node:10.16.0-alpine as frontend_builder

WORKDIR /code

# Установка библиотек
COPY yarn.lock .
COPY package.json .
COPY webpack.config.js .
COPY tsconfig.json .
RUN npm install

# Установка кода приложения
# COPY public public
COPY src src
RUN npm run-script build
# <----- ЗАКОНЧИЛСЯ fronteend_builder

FROM nginx:alpine

COPY --from=frontend_builder /code/build/ /usr/share/nginx/html
ADD nginx.conf /etc/nginx/conf.d/default.conf.template
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
