#!/bin/sh
set -e

[[ -f "$DB_PASSWORD_FILE" ]] && export DB_PASS=$(cat $DB_PASSWORD_FILE)
[[ -f "$LOCKBOX_MASTER_KEY_FILE" ]] && export LOCKBOX_MASTER_KEY=$(cat $LOCKBOX_MASTER_KEY_FILE)
[[ -f "$UBIBOT_ACCOUNT_KEY_FILE" ]] && export UBIBOT_ACCOUNT_KEY=$(cat $UBIBOT_ACCOUNT_KEY_FILE)
exec "$@"
