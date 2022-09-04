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

# latexindent用インストール
RUN apk add --no-cache gcc libc-dev make \
    perl-dev perl-app-cpanminus
    # wget tar unzip perl-dev perl-app-cpanminus \
RUN cpanm -v Log::Log4perl YAML::Tiny Log::Dispatch::File File::HomeDir Unicode::GCString

FROM alpine
# tex環境変数
ENV PATH /usr/local/texlive/2022/bin/x86_64-linuxmusl:$PATH
# tex コピー
COPY --from=installer /usr/local/texlive /usr/local/texlive
# latexindent コピー
COPY --from=installer /usr/lib /usr/lib
COPY --from=installer /usr/local/lib /usr/local/lib
COPY --from=installer /usr/local/share /usr/local/share

# 基本インストール
RUN apk add --no-cache perl curl ghostscript \
    make git \
    # 追加インストール
    py3-pip

# tlmgrのアップデート
RUN tlmgr update --self && \
    # minted用
    pip install pygments

WORKDIR /workdir
CMD ["ash"]
