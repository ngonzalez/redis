FROM --platform=linux/arm64 debian:bookworm AS build_arm64

# apt
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'deb http://mirrors.ocf.berkeley.edu/debian/ unstable main contrib non-free' > /etc/apt/sources.list
RUN apt-get update -yqq
RUN apt-get dist-upgrade -yq
RUN apt-get upgrade -yq

# debconf
RUN apt-get install -yq debconf libreadline-dev
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN dpkg-reconfigure debconf

# USER
ARG user="redis"
ENV USER=$user
RUN echo "USER=$USER" > /etc/profile.d/user.sh
RUN useradd -m $USER -s /bin/bash
RUN apt-get install -yq sudo
RUN echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# Entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# redis
RUN apt-get install -yqq curl gpg
RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb bookworm main" | tee /etc/apt/sources.list.d/redis.list
RUN apt-get update && apt-get install -yqq redis

ARG redis_port="6379"
ENV REDIS_PORT=$redis_port

COPY config/redis.conf /etc/redis/redis.conf
RUN sed -i "s/__PORT__/$REDIS_PORT/" /etc/redis/redis.conf
RUN chown $USER: /etc/redis/redis.conf
RUN mkdir -p /var/run/redis
RUN chown $USER: /var/run/redis

EXPOSE $REDIS_PORT

CMD ["entrypoint.sh", "--server"]
