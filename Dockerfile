FROM centos:centos7

WORKDIR /home
ADD "cmake-3.12.4-Linux-x86_64" "/home/cmake-3.12.4-Linux-x86_64"
ADD "go1.21.13" "/home/go1.21.13"
ADD "perl-5.40.0" "/home/perl-5.40.0"
ADD "openssl-1.1.1q" "/home/openssl-1.1.1q"
ADD "yum" "/home/yum"
# ENV HTTP_PROXY="http://10.214.224.168:7890"
# ENV HTTPS_PROXY="http://10.214.224.168:7890"
# ENV https_proxy="http://10.214.224.168:7890"
# ENV http_proxy="http://10.214.224.168:7890"

RUN cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
# RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
# RUN curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.tencent.com/repo/centos7_base.repo && yum clean all && yum makecache
# RUN curl -o /etc/yum.repos.d/CentOS-Base.repo https://gitee.com/fishfishfishfishfish/centos.repo/raw/master/CentOS-Base.repo && yum clean all && yum makecache
RUN cp /home/yum/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo && yum clean all && yum makecache
# RUN yum install -y wget && yum install -y git && git clone git@gitee.com:fishfishfishfishfish/centos.repo.git
RUN ln -s /home/go1.21.13/bin/go /usr/local/bin/go && \
    ln -s /home/cmake-3.12.4-Linux-x86_64/bin/cmake /usr/local/bin/cmake
RUN yum install -y scl-utils && yum install -y centos-release-scl
RUN cp /etc/yum.repos.d/CentOS-SCLo-scl.repo /etc/yum.repos.d/CentOS-SCLo-scl.repo.bak && \
    cp /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo.bak && \
    cp /home/yum/CentOS-SCLo-scl.repo /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
    cp /home/yum/CentOS-SCLo-scl-rh.repo /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
    yum clean all && yum makecache
RUN yum install -y devtoolset-11-toolchain
# RUN source /opt/rh/devtoolset-11/enable
# RUN echo -e '\nsource /opt/rh/devtoolset-11/enable' >> ~/.bashrc
# SHELL ["/bin/bash", "-c"]
SHELL [ "/usr/bin/scl", "enable", "devtoolset-11" ]
# RUN source scl_source enable devtoolset-11 && \
RUN cd /home/perl-5.40.0 && ./Configure -des -Dprefix=/usr/local/localperl && make -j6 && make -j6 test && make -j6 install && \
    ln -s /usr/local/localperl/bin/perl /usr/bin/perl && \
    cd /home/perl-5.40.0 && make install && cd /home/openssl-1.1.1q && ./config shared && make && make install && \
    ldd /usr/local/bin/openssl 
ENV LD_LIBRARY_PATH /usr/local/lib64:$LD_LIBRARY_PATH

