FROM ubuntu:14.04
MAINTAINER HJay <trixism@qq.com>

RUN \
# no history
 cp /root/.bashrc /root/.profile / ; \
 echo 'HISTFILE=/dev/null' >> /.bashrc ; \
 HISTSIZE=0 ; \
# timezone
 cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ; \
 sed -i 's/UTC=yes/UTC=no/' /etc/default/rcS ; \
# apt
 sed -i "s/archive.ubuntu.com/cn.archive.ubuntu.com/g" /etc/apt/sources.list ; \
 echo 'deb http://cn.archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list ; \
 echo 'deb-src http://cn.archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list ; \
 apt-get update ; \
 apt-get -y upgrade ; \
 apt-get -y --no-install-recommends install \
# base package
 curl git unzip supervisor iputils-ping netcat dnsutils python-setuptools wget psmisc \
 openssh-server vim bash-completion apt-transport-https debconf-utils ca-certificates \
 build-essential ; \
 apt-get clean ; \
 true

RUN \
 echo 'deb https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ trusty main' > /etc/apt/sources.list.d/gitlab_gitlab-ce.list ; \
 echo 'deb-src https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ trusty main' >> /etc/apt/sources.list.d/gitlab_gitlab-ce.list ; \
 echo 'postfix  postfix/mailname        string  gitlab.ygomi.net' | debconf-set-selections ; \
 echo 'postfix  postfix/main_mailer_type        select  Internet Site' | debconf-set-selections ; \
 curl https://packages.gitlab.com/gpg.key 2> /dev/null | apt-key add - &>/dev/null ; \
 apt-get update ; \
 apt-get install -y postfix gitlab-ce

VOLUME ["/var/opt/gitlab", "/var/log/gitlab"]
