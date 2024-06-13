FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y -q && apt upgrade -y -q && apt update -y -q && \
    apt install -y -q \
    python3-pip \
    python3-cffi \
    python3-brotli \
    libpango-1.0-0 \
    libharfbuzz0b \
    libpangoft2-1.0-0 \
    fonts-liberation \
    fonts-liberation2 \
    wget \
    libodbc1 \
    unixodbc \
    unixodbc-dev \
    openssl \
    libkrb5-3 \
    libc6 \
    e2fsprogs \
    curl

RUN pip install weasyprint==60.2

# Install MS ODBC drivers https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN apt-get install -y unixodbc-dev

WORKDIR /app

RUN mkdir -p resources

# COPY resources/* resources/

COPY ds24_app ds24_app

RUN apt install -y -q freetds-common freetds-bin freetds-dev

# RUN tsql -C

# it's best to put these ENVs into the Container App Environment variables, but then it's harder to test locally

# Important: ,1433
ENV MSSQL_SERVER=ds24-mssql.database.windows.net,1433
ENV MSSQL_DB=ds24-mssql-db
ENV MSSQL_USERNAME=ds24admin
# Important: quotes around pwd
ENV MSSQL_PASSWORD="nb#E\OSj[9O/mck1,"

# You can use tsql to test the settings
# RUN tsql -S ${MSSQL_SERVER} -U ${MSSQL_USERNAME} -P ${MSSQL_PASSWORD}

# This is important for our Delphi app

RUN apt install -y -q tdsodbc

RUN echo "[FreeTDS]" >> /etc/odbcinst.ini
RUN echo "Description = ODBC for FreeTDS" >> /etc/odbcinst.ini
RUN echo "Driver      = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so" >> /etc/odbcinst.ini
RUN echo "Setup       = /usr/lib/x86_64-linux-gnu/odbc/libtdsS.so" >> /etc/odbcinst.ini
RUN echo "FileUsage   = 1" >> /etc/odbcinst.ini

# RUN cat /etc/odbcinst.ini

# Your MSSQL server hostname should be in /etc/hosts - you can do this do this by docker building with --add-host name:ip
# RUN cat /etc/hosts

RUN ./ds24_app --version
RUN ./ds24_app --check

# This is to test the DB Connection when trying out the database connection locally during docker build, not recommended to leave this in
#  https://www.freetds.org/userguide/logging.html
# ENV TDSDUMP=/tmp/freetds.log
# RUN ./ds24_app --dbtest
# RUN cat /tmp/freetds.log

EXPOSE 80

CMD ["./ds24_app", "--resource-path=/app/resources", "--xmldoc-path=/app/XMLDocumentation", "--weasyprint-path=/usr/local/bin/weasyprint"]
