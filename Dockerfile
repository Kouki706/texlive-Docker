FROM alpine AS installer

ENV PATH /usr/local/texlive/2022/bin/x86_64-linuxmusl:$PATH

RUN apk add --no-cache curl perl tar fontconfig-dev freetype-dev && \
    mkdir /tmp/install-tl-unx && \
    curl http://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar zx -C /tmp/install-tl-unx --strip-components 1
RUN printf "%s\n%s\n%s\n" \
    "selected_scheme scheme-full" \
    "option_doc 0" \
    "option_src 0" \
    > /tmp/install-tl-unx/texlive.profile
RUN /tmp/install-tl-unx/install-tl \
    --profile=/tmp/install-tl-unx/texlive.profile \
    -repository=http://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet/

FROM alpine
ENV PATH /usr/local/texlive/2022/bin/x86_64-linuxmusl:$PATH
WORKDIR /workdir
COPY --from=installer /usr/local/texlive /usr/local/texlive

# 基本設定のインストール
RUN apk add --no-cache perl perl-utils curl ghostscript py3-pip make git

# tlmgrのアップデート
RUN tlmgr update --self && \
    # minted用
    pip install pygments && \
    # latexindent用
    echo "yes" | cpan Log::Log4perl YAML::Tiny Log::Dispatch::File File::HomeDir Unicode::GCString
CMD ["ash"]
