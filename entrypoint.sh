#!/bin/bash
set -e

# Ensure log directory exists and has correct permissions
mkdir -p /usr/local/lsws/logs /var/www/bedrock/logs
touch /usr/local/lsws/logs/error.log /usr/local/lsws/logs/access.log /usr/local/lsws/logs/stderr.log
touch /var/www/bedrock/logs/error.log /var/www/bedrock/logs/access.log
chown -R nobody:nogroup /usr/local/lsws/logs /var/www/bedrock/logs

# Stream logs to stdout and stderr of PID 1 (container output)
tail -n 0 -F /usr/local/lsws/logs/error.log > /proc/1/fd/2 &
tail -n 0 -F /usr/local/lsws/logs/stderr.log > /proc/1/fd/2 &
tail -n 0 -F /usr/local/lsws/logs/access.log > /proc/1/fd/1 &
tail -n 0 -F /var/www/bedrock/logs/error.log > /proc/1/fd/2 &
tail -n 0 -F /var/www/bedrock/logs/access.log > /proc/1/fd/1 &

# Run the original entrypoint
exec /entrypoint.sh "$@"
