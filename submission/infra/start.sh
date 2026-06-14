#!/bin/bash
/usr/sbin/sshd
if [ -f /etc/redis/redis.conf ]; then
  redis-server /etc/redis/redis.conf --daemonize yes
fi
tail -f /dev/null