FROM alpine:3.7

RUN apk --no-cache add nginx
RUN adduser -D -g 'www' www
RUN mkdir /www &&\
    mkdir -p /run/nginx &&\
    chown -R www:www /var/lib/nginx &&\
    chown -R www:www /www &&\
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www/index.html
EXPOSE 80 9000
CMD ["nginx", "-g", "daemon off;"]

