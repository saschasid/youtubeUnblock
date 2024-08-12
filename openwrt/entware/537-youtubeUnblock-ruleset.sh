#!/bin/sh

[ "$type" == "ip6tables" ] && exit 0   # check the protocol type in backward-compatible way
[ "$table" != "mangle" ] && exit 0   # check the table name

iptables -t mangle -A FORWARD -p tcp -m tcp --dport 443 -m connbytes --connbytes-dir original --connbytes-mode packets --connbytes 0:19 -j NFQUEUE --queue-num 537 --queue-bypass
iptables -I OUTPUT -m mark --mark 32768/32768 -j ACCEPT
