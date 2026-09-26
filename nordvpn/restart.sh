curl -X PUT -d '{"status":"stopped"}' http://127.0.0.1:8898/v1/vpn/status
sleep 2
curl -X PUT -d '{"status":"running"}' http://127.0.0.1:8898/v1/vpn/status

