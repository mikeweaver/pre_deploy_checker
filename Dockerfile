FROM invocaops/ruby:2.6.5-master


ARG RAILS_ENV
ARG BUNDLE_GEM__FURY__IO
ENV HOME_DIR="/usr/src/pre_deploy_checker"

RUN apt-get update && \
    apt-get install -y \
    apt-get install libmysqlclient-dev -y \
    build-essential \
    git-core \
    autoconf \
    sqlite3 \
    libsqlite3-dev \
    nodejs \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    gettext \
    libz-dev \
    libssl-dev \
    ssh && \
    # remove apt-get data to save space
    rm -rf /var/lib/apt/lists/* && \
    # install newer version of git for date parsing
    git clone git://git.kernel.org/pub/scm/git/git.git && \
    cd git && \
    git checkout 2bb64867dc05d9a8432488ddc1d22a194cee4d31 && \
    make configure && \
    ./configure --prefix=/usr && \
    make install && \
    # make a directory for our app
    mkdir -p ${HOME_DIR}

WORKDIR ${HOME_DIR}

COPY Gemfile .
COPY Gemfile.lock .

RUN \
# make SSH be quiet about githubs SSH key
mkdir -p /root/.ssh && \
ssh-keyscan github.com >> /root/.ssh/known_hosts && \
# install minimal set of required gems
bundle install --without test development

COPY . .

RUN \
# make some directories we need to run
mkdir -p shared/pids && \
mkdir -p log && \
mkdir -p data/db && \
# setup the DB and assets
bundle exec rake db:migrate RAILS_ENV=$RAILS_ENV VALIDATE_SETTINGS=false && \
bundle exec rake assets:precompile RAILS_ENV=$RAILS_ENV VALIDATE_SETTINGS=false
