FROM golang

COPY build.sh /

CMD ["/build.sh"]
