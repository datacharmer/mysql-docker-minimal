FROM ubuntu

MAINTAINER Giuseppe Maxia <gmax@cpan.org>

RUN apt-get update \
    && apt-get install -y make sudo libaio1 vim-tiny perl-modules libnuma1 bash-completion \
    && rm -rf /var/lib/apt/lists/* \
    && export USER=root \
    && export HOME=/root \
    && echo "source /etc/bash_completion" >> /root/.bashrc \
    && echo "export LD_LIBRARY_PATH=/opt/mysql/current:/usr/local/mysql/lib:/usr/lib:/usr/lib64:/lib:/lib64" >> /root/.bashrc \
    && echo "[ -f /opt/mysql/library_path.sh ] && source /opt/mysql/library_path.sh" >> /root/.bashrc \
    && ln -s /opt /root/opt

EXPOSE 3306
COPY dbdeployer /usr/bin/dbdeployer
COPY dbdeployer_completion.sh /etc/bash_completion.d/
COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
