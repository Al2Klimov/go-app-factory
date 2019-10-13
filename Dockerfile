FROM debian:stable-slim as dep-src
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

RUN apt-get update ;\
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-{recommends,suggests} -y \
		git ca-certificates ;\
	apt-get clean ;\
	rm -vrf /var/lib/apt/lists/*

COPY ensure-go-pkg.sh /

RUN /ensure-go-pkg.sh github.com/golang/dep          https://github.com/golang/dep.git          1f7c19e5f52f49ffb9f956f64c010be14683468b
RUN /ensure-go-pkg.sh github.com/Masterminds/semver  https://github.com/Masterminds/semver.git  24642bd0573145a5ee04f9be773641695289be46
RUN /ensure-go-pkg.sh github.com/Masterminds/vcs     https://github.com/Masterminds/vcs.git     3084677c2c188840777bff30054f2b553729d329
RUN /ensure-go-pkg.sh github.com/armon/go-radix      https://github.com/armon/go-radix.git      4239b77079c7b5d1243b7b4736304ce8ddb6f0f2
RUN /ensure-go-pkg.sh github.com/boltdb/bolt         https://github.com/boltdb/bolt.git         2f1ce7a837dcb8da3ec595b1dac9d0632f0f99e8
RUN /ensure-go-pkg.sh github.com/golang/protobuf     https://github.com/golang/protobuf.git     925541529c1fa6821df4e44ce2723319eb2be768
RUN /ensure-go-pkg.sh github.com/google/go-cmp       https://github.com/google/go-cmp.git       3af367b6b30c263d47e8895973edcca9a49cf029
RUN /ensure-go-pkg.sh github.com/jmank88/nuts        https://github.com/jmank88/nuts.git        8b28145dffc87104e66d074f62ea8080edfad7c8
RUN /ensure-go-pkg.sh github.com/nightlyone/lockfile https://github.com/nightlyone/lockfile.git e83dc5e7bba095e8d32fb2124714bf41f2a30cb5
RUN /ensure-go-pkg.sh github.com/pelletier/go-toml   https://github.com/pelletier/go-toml.git   c01d1270ff3e442a8a57cddc1c92dc1138598194
RUN /ensure-go-pkg.sh github.com/pkg/errors          https://github.com/pkg/errors.git          645ef00459ed84a119197bfb8d8205042c6df63d
RUN /ensure-go-pkg.sh github.com/sdboyer/constext    https://github.com/sdboyer/constext.git    836a144573533ea4da4e6929c235fd348aed1c80
RUN /ensure-go-pkg.sh golang.org/x/net               https://go.googlesource.com/net            66aacef3dd8a676686c7ae3716979581e8b03c47
RUN /ensure-go-pkg.sh golang.org/x/sync              https://go.googlesource.com/sync           f52d1811a62927559de87708c8913c1650ce4f26
RUN /ensure-go-pkg.sh golang.org/x/sys               https://go.googlesource.com/sys            bb24a47a89eac6c1227fbcb2ae37a8b9ed323366
RUN /ensure-go-pkg.sh gopkg.in/yaml.v2               https://gopkg.in/yaml.v2                   d670f9405373e636a5a2765eea47fac0c9bc91a4


FROM golang as dep-bin

COPY --from=dep-src /go /go

RUN ["go", "build", "-o", "/usr/local/bin/dep", "github.com/golang/dep/cmd/dep"]


FROM golang

COPY --from=dep-bin /usr/local/bin/dep /usr/local/bin/
COPY build.sh /

CMD ["/build.sh"]
