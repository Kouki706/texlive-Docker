FROM alpine AS installer

ENV PATH /usr/local/texlive/2019/bin/x86_64-linuxmusl:$PATH

RUN apk add --no-cache curl perl tar fontconfig-dev freetype-dev && \
  mkdir /tmp/install-tl-unx && \
  curl ftp://tug.org/historic/systems/texlive/2019/install-tl-unx.tar.gz | \
  tar -zx -C /tmp/install-tl-unx --strip-components 1 && \
  printf "%s\n%s\n%s\n" \
  "selected_scheme scheme-basic" \
  "option_doc 0" \
  "option_src 0" \
  > /tmp/install-tl-unx/texlive.profile && \
  /tmp/install-tl-unx/install-tl \
  --profile=/tmp/install-tl-unx/texlive.profile \
  -repository=ftp://tug.org/historic/systems/texlive/2019/tlnet-final/ && \
  rm -rf /tmp/install-tl-unx && \
  tlmgr install \
  collection-langenglish \
  collection-latexrecommended \
  collection-fontsrecommended \
  latexmk \
  latexdiff \
  paralist \
  cleveref

FROM alpine
ENV PATH /usr/local/texlive/2021/bin/x86_64-linuxmusl:$PATH
WORKDIR /workdir
COPY --from=installer /usr/local/texlive /usr/local/texlive
RUN apk add --no-cache perl curl ghostscript
CMD ["ash"]
