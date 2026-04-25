#!/bin/bash
# Health Check Script
SERVER_IP=$1
MAX_RETRIES=10
RETRY_INTERVAL=10

echo "========================================="
echo " Running Health Check on ${SERVER_IP}"
echo "========================================="

for i in $(seq 1 $MAX_RETRIES); do
    echo "Attempt ${i}/${MAX_RETRIES}..."
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 http://${SERVER_IP}/health)
    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "✅ Health Check PASSED!"
        exit 0
    else
        echo "HTTP ${HTTP_STATUS} - retrying in ${RETRY_INTERVAL}s..."
        sleep $RETRY_INTERVAL
    fi
done

echo "❌ Health Check FAILED!"
exit 1
