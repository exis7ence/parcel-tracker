FROM golang:1.22-alpine AS builder

RUN apk add --no-cache gcc musl-dev

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=1 go build -o parcel-tracker .

FROM alpine:latest

RUN apk add --no-cache sqlite ca-certificates

WORKDIR /app

COPY --from=builder /app/parcel-tracker .
COPY tracker.db* ./

VOLUME ["/app"]

CMD ["./parcel-tracker"]
