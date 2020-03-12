FROM centos:7
MAINTAINER dengyong<yodeng@tju.edu.cn>

ARG SOFTDIR=/opt/soft

WORKDIR /usr/local

ENV PATH="${SOFTDIR}/miniconda2/bin:$PATH"
ENV LD_LIBRARY_PATH="${SOFTDIR}/miniconda2/lib:$LD_LIBRARY_PATH"

RUN yum groupinstall -y "Development Tools"
RUN yum -y install bzip2-devel openssl-devel zlib-devel gcc readline-devel docker ftp lftp lrzsz libdb-devel zsh xz-devel wget libcurl-devel which vim epel-release

ADD http://rpms.remirepo.net/enterprise/7/remi/x86_64/remi-release-7.7-1.el7.remi.noarch.rpm .
RUN rpm -Uvh remi-release-7.7-1.el7.remi.noarch.rpm
RUN yum --enablerepo=remi -y install libxlsxwriter-devel

ADD https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh .
RUN chmod +x Miniconda2-latest-Linux-x86_64.sh
RUN ./Miniconda2-latest-Linux-x86_64.sh -b -p ${SOFTDIR}/miniconda2

COPY condarc /root/.condarc

RUN ${SOFTDIR}/miniconda2/bin/conda install -y perl-excel-writer-xlsx perl-statistics-descriptive perl-statistics-r htslib=1.9 perl-bioperl perl-gd perl-db-file r-ggplot2 r-reshape2 r-base bedtools seqtk vcftools bwa samtools sambamba pigz openjdk=8.0.192 gatk=3.6
RUN ${SOFTDIR}/miniconda2/bin/R -e "install.packages('argparser', repos='https://cran.rstudio.com/')"
RUN rm -fr Miniconda2-latest-Linux-x86_64.sh remi-release-7.7-1.el7.remi.noarch.rpm ${SOFTDIR}/miniconda2/pkgs/*

RUN ${SOFTDIR}/miniconda2/bin/pip install biopython==1.73 configparser==3.8.1 intervalnewtree==1.0.4 intervaltree==3.0.2 ipython==5.8.0 matplotlib==2.2.3 numpy==1.16.4 pandas==0.24.2 openpyxl==2.6.3 psutil==5.6.5 pysam==0.13 recordclass==0.12.0.1 rpy2==2.5.6 runjob scikit-learn==0.20.3 scipy==1.2.1 xlrd==1.2.0 xlsxwriter==1.1.8 xlwt==1.3.0 transvar docker --index-url http://pypi.doubanio.com/simple --trusted-host pypi.doubanio.com
