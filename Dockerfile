FROM golang:1.13-alpine as builder
RUN mkdir /build
WORKDIR /build
ADD *.go go.* ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -o estafette-gke-preemptible-killer .

FROM alpine:3.12
LABEL maintainer="estafette.io" \
      description="The estafette-gke-preemptible-killer component is a Kubernetes controller that ensures preemptible nodes in a Container Engine cluster don't expire at the same time"

RUN apk --no-cache add ca-certificates

COPY --from=builder /build/estafette-gke-preemptible-killer /

CMD ["./estafette-gke-preemptible-killer"]
