#!/bin/bash

: "${GC_SSH_PORT?You need to set GC_SSH_PORT in .env}"
: "${GC_SG_ID?You need to set GC_SG_ID in .env}"

CURRENT_USER=$(whoami)
WAN_IP=$(curl v4.ifconfig.co)
GC_INBOUND_PROTOCOL=${GC_INBOUND_PROTOCOL:-'tcp'}

echo "Removing IP: $WAN_IP to AWS SG: $GC_SG_ID - Port: $GC_SSH_PORT - Protocol: $GC_INBOUND_PROTOCOL"
aws ec2 revoke-security-group-ingress --group-id "$GC_SG_ID" \
    --ip-permissions IpProtocol="$GC_INBOUND_PROTOCOL",FromPort="$GC_SSH_PORT",ToPort="$GC_SSH_PORT",IpRanges=" [{CidrIp=$WAN_IP/32,Description=$CURRENT_USER - $(date)}]"
echo "Removed!"