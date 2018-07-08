FROM ruby
RUN apt-get update &&\
    apt-get install vim zip -y &&\
    gem install  aws-sdk pry rake awesome_print
RUN mkdir /opt/app
COPY . /opt/app/
WORKDIR /opt/app
ENTRYPOINT ["rake"]
