#!/usr/bin/env bash
# Forward the app service locally first: kubectl port-forward svc/lightweight-app-service 8080:80 -n production

URL="http://localhost:8080"

echo "🔥 Initiating synthetic traffic generation spike..."
echo "Press [CTRL+C] to stop the load test."

while true; do
  # Generate parallel background curl bursts to simulate a real-world user spike
  for i in {1..50}; do
    curl -s -o /dev/null -w "%{http_code}" "$URL" &
  done
  sleep 0.1
done
