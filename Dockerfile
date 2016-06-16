##############################################################################################
# Dockerfile to build ReadTheDocs
# Can be used to build RTD locally to test Sphinx build
# See RTD installation instructions http://read-the-docs.readthedocs.io/en/latest/install.html 
##############################################################################################

FROM python:2

MAINTAINER Will Barnes

# update and install needed applications from apt-get
RUN apt-get update -qq && apt-get install -y -qq \ 
  git \
  build-essential \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev

# pip tools
RUN pip install --upgrade pip

# set default directory for command to execute
WORKDIR /home/rtd/checkouts/readthedocs.org

# initial setup
RUN git clone https://github.com/rtfd/readthedocs.org.git /home/rtd/checkouts/readthedocs.org

## install dependencies
RUN pip install -r requirements.txt

# setup the server
CMD python manage.py migrate
CMD python manage.py createsuperuser
CMD python manage.py collectstatic

# set user and password
ENV SLUMBER_USERNAME admin
ENV SLUMBER_PASSWORD passwd

# Expose port 8000
EXPOSE 8000

# run the server
CMD python manage.py runserver 0.0.0.0:8000