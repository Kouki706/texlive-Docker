FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# install general packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    locales && \
    # clean to reduce image size
    apt-get clean -y && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

# install texlive
RUN mkdir /tmp/install-tl-unx && \
    wget -P /tmp/install-tl-unx http://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz --no-check-certificate && \
    tar zxvf /tmp/install-tl-unx/install-tl-unx.tar.gz -C /tmp/install-tl-unx --strip-components 1 && \
    printf "%s\n%s\n%s\n" \
    "selected_scheme scheme-basic" \
    "option_doc 0" \
    "option_src 0" \
    > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
    --profile=/tmp/install-tl-unx/texlive.profile \
    -repository http://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet/ && \
    rm -rf /tmp/install-tl-unx

# add TeX Live to PATH
ENV PATH /usr/local/texlive/2020/bin/x86_64-linux:$PATH

# install LaTeX packages with tlmgr
RUN tlmgr install \
    latexmk \
    collection-latexextra \
    collection-latexrecommended \
    collection-fontsrecommended \
    collection-langjapanese
