FROM ubuntu:16.04

ENV RBENV_VERSION 2.4.1

RUN export DEBIAN_FRONTEND='noninteractive'
RUN export TZ="America/Los_Angeles"

RUN apt-get update && apt-get install --yes \
    build-essential \
    curl \
    git \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
&& rm -rf /var/lib/apt/lists/*

RUN git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv \
&&  git clone git://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build \
&&  /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh \
&&  echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /root/.bashrc \
&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc

RUN echo 'gem: --no-document' >> /etc/gemrc \
&& echo 'gem: --no-document' >> /root/.gemrc

ENV RUBY_CONFIGURE_OPTS="--disable-install-doc"
ENV PATH /usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH

RUN eval "$(rbenv init -)"; rbenv install $RBENV_VERSION \
&&  eval "$(rbenv init -)"; rbenv global $RBENV_VERSION \
&&  eval "$(rbenv init -)"; gem update --system \
&&  eval "$(rbenv init -)"; gem install bundler -f \
&&  rm -rf /tmp/*
