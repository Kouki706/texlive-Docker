FROM alpine

ENV PATH /usr/local/texlive/2021/bin/x86_64-linuxmusl:$PATH

RUN apk add --no-cache curl perl openssh git && \
    apk add --no-cache --virtual .fetch-deps tar && \
    mkdir /tmp/install-tl-unx && \
    curl http://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar zx -C /tmp/install-tl-unx --strip-components 1 && \
    printf "%s\n%s\n%s\n" \
        "selected_scheme scheme-basic" \
        "option_doc 0" \
        "option_src 0" \
    > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
        --profile=/tmp/install-tl-unx/texlive.profile \
        -repository http://ftp.yz.yamagata-u.ac.jp/pub/CTAN/systems/texlive/tlnet/ && \
    rm -rf /tmp/install-tl-unx && \
    tlmgr install \
    collection-langjapanese \
    collection-latexrecommended \
    collection-fontsrecommended \
    latexmk && \
    apk del .fetch-deps
    
    #     collection-latexextra \
