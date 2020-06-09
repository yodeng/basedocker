FROM centos:7
MAINTAINER dengyong<yodeng@tju.edu.cn>

ARG SOFTDIR=/opt/soft

WORKDIR /usr/local

ENV PATH="${SOFTDIR}/miniconda2/bin:$PATH"
ENV LD_LIBRARY_PATH="${SOFTDIR}/miniconda2/lib:$LD_LIBRARY_PATH"

RUN yum groupinstall -y "Development Tools"
RUN yum -y install bzip2-devel openssl-devel zlib-devel gcc readline-devel docker ftp lftp lrzsz libdb-devel zsh xz-devel wget libcurl-devel which vim epel-release

ADD remi-release-7.7-1.el7.remi.noarch.rpm .
RUN rpm -Uvh remi-release-7.7-1.el7.remi.noarch.rpm
RUN yum --enablerepo=remi -y install libxlsxwriter-devel

ADD Miniconda2-latest-Linux-x86_64.sh .
RUN chmod +x Miniconda2-latest-Linux-x86_64.sh
RUN ./Miniconda2-latest-Linux-x86_64.sh -b -p ${SOFTDIR}/miniconda2

COPY condarc /root/.condarc
ADD base.conda.envs .
ADD python3.conda.envs .
ADD base.pypi.envs .

RUN ${SOFTDIR}/miniconda2/bin/conda install --file base.conda.envs
RUN ${SOFTDIR}/miniconda2/bin/conda create --name python3 --file python3.conda.envs
RUN ${SOFTDIR}/miniconda2/bin/Rscript -e "install.packages('argparser', repos='https://cran.rstudio.com/')"

RUN ${SOFTDIR}/miniconda2/bin/pip install --force-reinstall -r base.pypi.envs --index-url http://pypi.doubanio.com/simple --trusted-host pypi.doubanio.com

RUN rm -fr Miniconda2-latest-Linux-x86_64.sh base.conda.envs python3.conda.envs base.pypi.envs remi-release-7.7-1.el7.remi.noarch.rpm ${SOFTDIR}/miniconda2/pkgs/*
