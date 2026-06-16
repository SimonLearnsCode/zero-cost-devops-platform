# Create the directory
mkdir -p app

# Create a sample, secure Dockerfile
cat <<EOF > app/Dockerfile
FROM alpine:3.19.1
RUN apk add --no-cache nodejs npm
WORKDIR /app
COPY . .
CMD ["node", "-v"]
EOF
