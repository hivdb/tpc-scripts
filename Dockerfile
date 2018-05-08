FROM valearna/ubuntu-tpc-base
WORKDIR /data
RUN apt-get update -qyy && \
    apt-get install -qy apache2 libfcgi-dev libapache2-mod-fastcgi sudo python-pip
RUN git clone https://github.com/TextpressoDevelopers/textpressocentral.git && \
    git clone https://github.com/TextpressoDevelopers/tpctools.git && \
    git clone https://github.com/TextpressoDevelopers/textpressoapi.git && \
    git clone https://github.com/TextpressoDevelopers/textpresso_classifiers.git
RUN mkdir -p tpctools/build && cd tpctools/build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && make install
RUN mkdir -p textpressoapi/build && cd textpressoapi/build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    pip install -r ../requirements.txt && \
    make && make install
RUN cd textpresso_classifiers && pip install .
RUN mkdir -p textpressocentral/build && cd textpressocentral/build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j 10 && make install && \
    /usr/local/bin/tpctl.sh activate && \
    /usr/local/bin/tpctl.sh set_literature_dir /data/textpresso

EXPOSE 80
CMD ["default"]
ENTRYPOINT ["/data/textpressocentral/run.sh"]
