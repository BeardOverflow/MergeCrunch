FROM debian:stretch

RUN apt-get update && apt-get install -y \
    locales \
    locales-all

ENV \
LANG=en_US.UTF-8 \
LANGUAGE=en_US.UTF-8 \
LC_ALL=en_US.UTF-8 \
PYTHONUNBUFFERED=1

RUN apt-get update && apt-get -y install \
  bash \
  curl \
  mkvtoolnix \
  fontconfig \
  rhash \
  youtube-dl \
  wget

RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && \
  chmod a+rx /usr/local/bin/youtube-dl

RUN ln -s /root/.fonts /fonts

VOLUME [ "/downloads", "/fonts" ]

WORKDIR /downloads

ENTRYPOINT [ "/app/mergecrunch.sh" ]

COPY . /app

