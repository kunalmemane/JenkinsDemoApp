# Use a minimal base image for the build stage
FROM golang:1.22 AS builder

WORKDIR /app

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Use a minimal base image for the final stage
FROM registry.access.redhat.com/ubi9/ubi:9.6-1749542372

# Install ca-certificates for HTTPS support if needed
RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/main .

# Expose the port the application listens on
EXPOSE 8080

# Command to run the application
CMD ["./main"]