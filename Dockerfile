FROM ubuntu:18.04

RUN apt update && apt -y install gnupg2 inkscape curl git locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

# RUN gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
# RUN curl -sSL https://get.rvm.io | bash -s
# RUN source /etc/profile.d/rvm.sh && rvm install 3.0.2 && rvm use 3.0.2 && gem update bundler

VOLUME /certificates

WORKDIR /certificates
