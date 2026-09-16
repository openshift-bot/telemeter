FROM quay-proxy.ci.openshift.org/openshift/ci:ocp_builder_rhel-9-golang-1.24-openshift-4.20
ENV GOFLAGS="-mod=vendor"
COPY . /go/src/github.com/openshift/telemeter
RUN cd /go/src/github.com/openshift/telemeter && \
    go build ./cmd/telemeter-client && \
    go build ./cmd/telemeter-server && \
    go build ./cmd/rhelemeter-server && \
    go build ./cmd/authorization-server

FROM quay-proxy.ci.openshift.org/openshift/ci:ocp_4.20_base-rhel9
LABEL io.k8s.display-name="OpenShift Telemeter" \
      io.k8s.description="" \
      io.openshift.tags="openshift,monitoring" \
      summary="" \
      maintainer="OpenShift Monitoring Team <team-monitoring@redhat.com>"

COPY --from=0 /go/src/github.com/openshift/telemeter/telemeter-client /usr/bin/
COPY --from=0 /go/src/github.com/openshift/telemeter/telemeter-server /usr/bin/
COPY --from=0 /go/src/github.com/openshift/telemeter/rhelemeter-server /usr/bin/
COPY --from=0 /go/src/github.com/openshift/telemeter/authorization-server /usr/bin/
