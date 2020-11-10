FROM centos:7
MAINTAINER dengyong<yodeng@tju.edu.cn>

ARG SOFTDIR=/opt/soft

WORKDIR /usr/local

ENV PATH="${SOFTDIR}/miniconda2/bin:$PATH"
ENV LD_LIBRARY_PATH="${SOFTDIR}/miniconda2/lib:$LD_LIBRARY_PATH"

RUN yum groupinstall -y "Development Tools" \
    && yum -y install bzip2-devel openssl-devel zlib-devel gcc readline-devel docker ftp lftp lrzsz libdb-devel zsh xz-devel wget libcurl-devel which vim epel-release

ADD https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh base.conda.envs python3.conda.envs base.pypi.envs remi-release-7.7-1.el7.remi.noarch.rpm ./
COPY condarc /root/.condarc

RUN rpm -Uvh remi-release-7.7-1.el7.remi.noarch.rpm \
    && yum --enablerepo=remi -y install libxlsxwriter-devel \
    && chmod +x Miniconda2-latest-Linux-x86_64.sh \
    && ./Miniconda2-latest-Linux-x86_64.sh -b -p ${SOFTDIR}/miniconda2 \
    && ${SOFTDIR}/miniconda2/bin/conda install --file base.conda.envs \
    && ${SOFTDIR}/miniconda2/bin/conda create --name python3 --file python3.conda.envs \
    && ${SOFTDIR}/miniconda2/bin/Rscript -e "install.packages('argparser', repos='https://cran.rstudio.com/')" \
    && ${SOFTDIR}/miniconda2/bin/pip install --force-reinstall -r base.pypi.envs --index-url http://pypi.doubanio.com/simple --trusted-host pypi.doubanio.com \
    && rm -fr Miniconda2-latest-Linux-x86_64.sh base.conda.envs python3.conda.envs base.pypi.envs remi-release-7.7-1.el7.remi.noarch.rpm ${SOFTDIR}/miniconda2/pkgs/*
