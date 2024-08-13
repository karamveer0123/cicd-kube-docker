FROM rockylinux:9.3
MAINTAINER "Karamveer Singh"
RUN yum update -y && yum install nginx -y && systemctl enable nginx
COPY Dockerfile .
RUN rm -frv /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
