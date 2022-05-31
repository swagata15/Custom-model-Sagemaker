FROM ubuntu:16.04

MAINTAINER Amazon AI <sage-learner@amazon.com>

RUN apt-get -y update && apt-get install -y --no-install-recommends \
         wget \
         python3.5 \
         nginx \
		 libgcc-5-dev \
         ca-certificates \
	 libevent-dev \
	 python-all-dev \
	 python3-dev \
    && rm -rf /var/lib/apt/lists/*

        
        
RUN wget https://bootstrap.pypa.io/pip/3.5/get-pip.py && python3.5 get-pip.py
RUN pip3 install numpy==1.16.2 scipy==1.2.1 scikit-learn==0.20.2 xgboost==0.72.1 cpt pandas flask statsmodels  datetime  boto3  joblib
RUN pip install gevent
RUN pip3 install gunicorn && \
        (cd /usr/local/lib/python3.5/dist-packages/scipy/.libs; rm *; ln ../../numpy/.libs/* .) && \
        rm -rf /root/.cache

# Set some environment variables. PYTHONUNBUFFERED keeps Python from buffering our standard
# output stream, which means that logs can be delivered to the user quickly. PYTHONDONTWRITEBYTECODE
# keeps Python from writing the .pyc files which are unnecessary in this case. We also update
# PATH so that the train and serve programs are found when the container is invoked.

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"

# Set up the program in the image
COPY custom /opt/program
WORKDIR /opt/program




