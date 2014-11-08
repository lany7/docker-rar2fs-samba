FROM joelpet/debian:jessie

RUN sed --in-place 's/ftp.us.debian.org/ftp.se.debian.org/' /etc/apt/sources.list

RUN ( \
        export DEBIAN_FRONTEND=noninteractive; \
        apt-get update && \
        apt-get -y install build-essential libfuse-dev samba \
    )

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

# Add entrypoint script
ADD entrypoint.sh /src/

# Install entrypoint script and clean up sources
RUN install /src/entrypoint.sh /usr/local/bin && \
    rm -r /src

WORKDIR /

VOLUME /mnt/source
VOLUME /mnt/mountpoint

# Expose smbd and nmbd ports
EXPOSE 139/tcp 445/tcp
EXPOSE 137/udp 138/udp

ENTRYPOINT ["entrypoint.sh"]
CMD ["/mnt/source", "/mnt/mountpoint"]
