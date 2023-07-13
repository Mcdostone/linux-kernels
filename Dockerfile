FROM ubuntu:latest
RUN apt update
RUN apt install -y python3 python3-bs4 python3-requests
COPY get_kernels.py /tmp/get.py
WORKDIR /tmp
#ENTRYPOINT ["python3", "/tmp/get.py"]
CMD ["python3", "/tmp/get.py"]