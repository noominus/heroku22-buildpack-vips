FROM heroku/heroku:22

ARG VIPS_VERSION

ENV DEBIAN_FRONTEND noninteractive

# useful build tools ... we need gtk-doc to build orc, since they don't ship
# pre-baked tarballs
RUN apt-get update && apt-get install -y \
  build-essential \
  autoconf \
  automake \
  libtool \
  intltool \
  gtk-doc-tools \
  unzip \
  wget \
  git \
  pkg-config


# heroku:18 includes some libraries, like tiff and jpeg, as part of the
# run-time platform, and we want to use those libs if we can
#
# see https://devcenter.heroku.com/articles/stack-packages
#
# libgsf needs libxml2
RUN apt-get update && apt-get install -y \
  glib-2.0-dev \
  libexpat-dev \
  librsvg2-dev \
  libpng-dev \
  libjpeg-dev \
  libtiff5-dev \
  libexif-dev \
  liblcms2-dev \
  libxml2-dev \
  libfftw3-dev \
  libpoppler-glib-dev \
  libx265-dev \
  libde265-dev

ARG GIFLIB_VERSION=5.1.4
ARG GIFLIB_URL=http://downloads.sourceforge.net/project/giflib

RUN cd /usr/src \
  && wget ${GIFLIB_URL}/giflib-$GIFLIB_VERSION.tar.bz2 \
  && tar xf giflib-${GIFLIB_VERSION}.tar.bz2 \
  && cd giflib-${GIFLIB_VERSION} \
  && ./configure --prefix=/usr/src/vips \
  && make \
  && make install

ARG ORC_VERSION=0.4.29
ARG ORC_URL=https://gitlab.freedesktop.org/gstreamer/orc/-/archive/

RUN cd /usr/src \
  && wget ${ORC_URL}/$ORC_VERSION/orc-$ORC_VERSION.tar.gz -O orc-${ORC_VERSION}.tar.gz \
  && tar xf orc-${ORC_VERSION}.tar.gz \
  && cd orc-${ORC_VERSION} \
  && ./autogen.sh \
  && ./configure --prefix=/usr/src/vips --disable-gtk-doc \
  && make \
  && make install

ARG GSF_VERSION=1.14.50
ARG GSF_URL=https://ftp.gnome.org/pub/GNOME/sources/libgsf

RUN cd /usr/src \
  && wget ${GSF_URL}/${GSF_VERSION%.*}/libgsf-$GSF_VERSION.tar.xz \
  && tar xf libgsf-${GSF_VERSION}.tar.xz \
  && cd libgsf-${GSF_VERSION} \
  && ./configure --prefix=/usr/src/vips --disable-gtk-doc \
  && make \
  && make install


# ARG LIBDE265_VERSION=1.0.9
#
# RUN cd /usr/src \
#   && wget https://github.com/strukturag/libde265/releases/download/v${LIBDE265_VERSION}/libde265-${LIBDE265_VERSION}.tar.gz
#   && tar -xvf libheif-$LIBDE265_VERSION.tar.gz \
#   && cd libheif-$LIBDE265_VERSION \
#   && ./autogen.sh \
#   && ./configure --prefix=/usr/src/vips \
#   && make \
#   && make install

# BUILD HEIF from src, so that we make sure to add libde265 support
ARG HEIF_VERSION=1.14.0
ARG HEIF_URL=https://github.com/strukturag/libheif/releases/download

RUN cd /usr/src \
  && wget ${HEIF_URL}/v${HEIF_VERSION}/libheif-${HEIF_VERSION}.tar.gz \
  && tar xzf libheif-${HEIF_VERSION}.tar.gz \
  && cd libheif-${HEIF_VERSION} \
  && ./configure --prefix=/usr/src/vips \
  && make \
  && make install

ARG WEBP_VERSION=1.2.4

RUN cd /usr/src \
      && wget https://github.com/webmproject/libwebp/archive/v$WEBP_VERSION.tar.gz \
      && tar -xvf v$WEBP_VERSION.tar.gz \
      && cd libwebp-$WEBP_VERSION \
      && ./autogen.sh \
      && ./configure --prefix=/usr/src/vips --enable-libwebpmux --enable-libwebpdemux --enable-libwebpdecoder \
      && make \
      && make install


ARG IMAGEMAGICK_VERSION=7.1.0-52
ARG IMAGEMAGICK_URL=https://imagemagick.org/archive/

RUN cd /usr/src \
      && wget ${IMAGEMAGICK_URL}/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz \
      && tar -xvf ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz \
      && cd ImageMagick-${IMAGEMAGICK_VERSION} \
      && ./configure --prefix=/usr/src/vips --with-modules \
      && make \
      && make install


ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN cd /usr/src \
  && wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
  && tar xzf vips-${VIPS_VERSION}.tar.gz \
  && cd vips-${VIPS_VERSION} \
  && export PKG_CONFIG_PATH=/usr/src/vips/lib/pkgconfig \
  && ./configure --prefix=/usr/src/vips --disable-gtk-doc --with-modules \
  && make \
  && make install

# clean the build area ready for packaging
RUN cd /usr/src/vips \
  && rm bin/gif* bin/orc* bin/gsf* bin/batch_* bin/vips-* \
  && rm bin/vipsprofile bin/light_correct bin/shrink_width \
  && strip lib/*.a lib/lib*.so* \
  && rm -rf share/gtk-doc \
  && rm -rf share/man \
  && rm -rf share/thumbnailers

RUN cd /usr/src/vips \
  && rm -rf build \
  && mkdir build \
  && tar czf \
    /usr/src/vips/build/libvips.tar.gz bin include lib
