#!/usr/bin/env bash

set -x

HOSTNAME=`curl http://169.254.169.254/latest/meta-data/public-hostname`

PARAMS=(
  -it acapy_plugin_toolbox.http_ws 0.0.0.0 "$PORT"
  -ot http
  -e "http://$HOSTNAME:$PORT" "ws://$HOSTNAME:$PORT"
  --label "$AGENT_NAME"
  --auto-accept-requests --auto-ping-connection
  --auto-respond-credential-proposal
  --auto-respond-credential-offer
  --auto-respond-credential-request
  --auto-store-credential
  --auto-respond-presentation-proposal
  --auto-respond-presentation-request
  --auto-verify-presentation
  --invite
  --invite-role admin
  --invite-label "$AGENT_NAME(admin)"
  --genesis-url https://raw.githubusercontent.com/sovrin-foundation/sovrin/master/sovrin/pool_transactions_sandbox_genesis
  --wallet-type indy
  --plugin acapy_plugin_toolbox
  --debug-connections
  --debug-credentials
  --debug-presentations
  --enable-undelivered-queue
)

if [ -n "$ADMIN_PORT" ]; then
  PARAMS+=(
    --admin 0.0.0.0 $ADMIN_PORT
    --admin-api-key $ADMIN_API_KEY
  )
fi

aca-py start ${PARAMS[@]} "$@"
