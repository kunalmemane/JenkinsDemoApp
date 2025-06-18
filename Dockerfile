FROM quay.io/lib/golang:latest AS builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 go build -o main .

# Use a minimal base image for the final stage
FROM registry.access.redhat.com/ubi9/ubi:9.6-1749542372

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]