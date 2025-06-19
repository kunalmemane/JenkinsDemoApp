# Use a Redhat go-toolset image for golang
FROM registry.access.redhat.com/ubi8/go-toolset AS builder

COPY --chown=1001:0 . /app

WORKDIR /app

RUN CGO_ENABLED=0 go build -buildvcs=false -o main .

# Use a minimal base image for the final stage
FROM registry.access.redhat.com/ubi9/ubi:9.6-1749542372

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]