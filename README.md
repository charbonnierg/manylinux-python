## Manylinux Python Docker Images with ARMv7 support

## Image overview

### Base Image

Debian 9 (stretch)

### Additional packages

The following packages are installed using `apt-get`:

- build-essential
- ca-certificates
- checkinstall
- comerr-dev
- curl
- git
- libbz2-dev 
- libc6-dev
- libcurl4-openssl-dev
- libdb-dev
- libffi-dev 
- libgdbm-dev
- libkeyutils-dev
- liblzma-dev
- libncurses5-dev
- libpcap-dev
- libreadline-dev
- libsqlite3-dev
- libssl-dev
- linux-kernel-headers
- openssl
- uuid-dev
- wget
- zlib1g-dev

### Custom OpenSSL build

Python 3.10 needs OpenSSL >= 1.1.1 but the version available using `apt-get` is 1.1.0, as such it is required to build OpenSSL manually.

Custom build is installed into `/usr/local/ssl`.

### CPython interpreters

CPython interpreters are installed for:

- Python 3.7
- Python 3.8
- Python 3.9
- Python 3.10

The following configuration is used when compiling CPython from source:

```bash
LDFLAGS="${LDFLAGS} -Wl,-rpath=/usr/local/ssl/lib" ./configure \
  --prefix=$PREFIX \
  --with-ensurepip=upgrade \
  --disable-ipv6 \
  --with-openssl=/usr/local/ssl \
  --with-openssl-rpath=auto
```
