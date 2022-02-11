FROM centos:7.2.1511

RUN yum -y update; exit 0
RUN yum -y install https://repo.ius.io/ius-release-el7.rpm && \
    rpm --rebuilddb && \
    yum -y install make gcc git224 kde-l10n-Chinese && \
    yum -y reinstall glibc-common && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \ 
    rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && yum -y install nginx

ENV VSCODE_TAG=1.63.2 \
    PATH=$GOPATH/bin:$GOROOT/bin:$PATH \
    LANG=zh_CN.utf8

ADD https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v${VSCODE_TAG}/openvscode-server-v${VSCODE_TAG}-linux-x64.tar.gz /

COPY default.conf /etc/nginx/conf.d/default.conf
COPY setup.sh /setup.sh

RUN tar xzf openvscode-server-v${VSCODE_TAG}-linux-x64.tar.gz && \
    rm -f *.tar.gz && \
    mv /openvscode-server-v${VSCODE_TAG}-linux-x64 /openvscode && \
    chmod 777 /setup.sh

EXPOSE 3000

CMD ["bash", "/setup.sh" ]