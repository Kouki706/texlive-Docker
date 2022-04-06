FROM alpine AS installer

ENV PATH /usr/local/texlive/2022/bin/x86_64-linuxmusl:$PATH

RUN apk add --no-cache curl perl tar fontconfig-dev freetype-dev && \
    mkdir /tmp/install-tl-unx && \
    curl http://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar zx -C /tmp/install-tl-unx --strip-components 1
RUN printf "%s\n%s\n%s\n" \
    "selected_scheme scheme-basic" \
    "option_doc 0" \
    "option_src 0" \
    > /tmp/install-tl-unx/texlive.profile
RUN /tmp/install-tl-unx/install-tl \
    --profile=/tmp/install-tl-unx/texlive.profile \
    -repository=http://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet/ && \
    tlmgr install \
    collection-langjapanese \
    collection-latexrecommended \
    collection-fontsrecommended \
    latexmk \
    light-latex-make

FROM alpine
ENV PATH /usr/local/texlive/2022/bin/x86_64-linuxmusl:$PATH
WORKDIR /workdir
COPY --from=installer /usr/local/texlive /usr/local/texlive
RUN apk add --no-cache perl curl ghostscript
CMD ["ash"]
