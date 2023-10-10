FROM python:3.9.18-bullseye

MAINTAINER datapunt@amsterdam.nl

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

WORKDIR /app

COPY ca/* /usr/local/share/ca-certificates/extras/

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* /var/cache/debconf/*-old \
 && pip install --upgrade pip \
 && pip install uwsgi \
 && chmod -R 644 /usr/local/share/ca-certificates/extras/ \
 && update-ca-certificates

EXPOSE 8080

COPY requirements.txt /app/
RUN pip install uwsgi \
 && pip install -r requirements.txt \
 && adduser --system postcode

COPY . /app/
RUN chmod 755 /app/docker-run.sh

USER postcode

CMD ["/app/docker-run.sh"]
