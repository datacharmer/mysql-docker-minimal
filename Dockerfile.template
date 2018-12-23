FROM busybox

MAINTAINER Giuseppe Maxia <gmax@cpan.org>

RUN mkdir -p /opt/mysql/__VERSION__
COPY dbdata/__VERSION__ /opt/mysql/__VERSION__
RUN ln -s /opt/mysql/__VERSION__ /opt/mysql/current
COPY dbdata/__VERSION__/install.sh /opt/mysql
COPY dbdata/__VERSION__/library_path.sh /opt/mysql

CMD "chdir /opt/mysql"
