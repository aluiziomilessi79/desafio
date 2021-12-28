# Imagem utilizada
FROM nginx:alpine
# Copia dos arquivos pagina 
RUN mkdir /usr/share/nginx/html/sie-pagarme.fld
COPY ./site/sie-pagarme.fld/* /usr/share/nginx/html/sie-pagarme.fld/
COPY ./site/index.html /usr/share/nginx/html/
# Porta Utilizada
EXPOSE 80
# syntax=docker/dockerfile:1
ARG buildno
RUN echo "Build number: $buildno"