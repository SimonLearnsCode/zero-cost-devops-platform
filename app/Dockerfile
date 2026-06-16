# Stage 1: The Builder (We use a full image just to gather dependencies)
FROM alpine:3.21.3 AS builder
RUN apk add --no-cache nodejs npm
WORKDIR /app
COPY package*.json ./
# If you don't have a package.json yet, this command won't fail
RUN npm install --production || true 
COPY . .

# Stage 2: The Production Vault (Distroless runtime)
# This contains ONLY the Google node runtime engine—no OS junk!
FROM gcr.io/distroless/nodejs22-debian12
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 8080
CMD ["main.js"]
