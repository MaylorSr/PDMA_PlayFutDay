# FROM node:16.17.1 as build-step
# RUN mkdir -p /usr/local/app
# WORKDIR /usr/local/app
# COPY ./ /usr/local/app
# RUN npm install
# RUN npm run build --prod

# FROM nginx:latest
# RUN rm -rf /usr/share/nginx/html*
# COPY --from=build-step /usr/local/app/dist /usr/share/nginx/html


# EXPOSE 80

FROM nginx:latest
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build-step /usr/local/app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
