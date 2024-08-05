FROM locustio/locust

RUN pip install locust-graphql-client

WORKDIR /mnt/locust

COPY locustfile.py /mnt/locust

ENTRYPOINT [ "locust"]