FROM mariadb:10
RUN apt-get update && apt-get install -y curl
RUN apt install -y python2.7
RUN curl https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin
RUN mkdir /code
WORKDIR /code
COPY ./restore.sh .
ENTRYPOINT ["/bin/bash"]
CMD ["restore.sh"]
