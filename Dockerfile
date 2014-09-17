FROM joelpet/debian:testing

RUN sed --in-place 's/ftp.us.debian.org/ftp.se.debian.org/' /etc/apt/sources.list

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install \
    build-essential \
    libfuse-dev \
    samba

# Add rar2fs and unrar source
ADD rar2fs-1.20.0.tar.gz /src/
ADD unrarsrc-5.1.7.tar.gz /src/rar2fs-1.20.0/

# Build and install unrar lib
WORKDIR /src/rar2fs-1.20.0/unrar
RUN make lib install-lib

# Build and install rar2fs
WORKDIR /src/rar2fs-1.20.0
RUN ./configure; make; make install

# Configure Samba server
ADD smb.conf /etc/samba/smb.conf

# Install entrypoint script
ADD entrypoint.sh /src/
RUN install /src/entrypoint.sh /usr/local/bin

WORKDIR /

VOLUME /mnt/source
VOLUME /mnt/mountpoint

EXPOSE 445
EXPOSE 139
EXPOSE 135

ENTRYPOINT ["entrypoint.sh"]
CMD ["/mnt/source", "/mnt/mountpoint"]
