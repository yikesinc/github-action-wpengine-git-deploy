#!/bin/sh -l

set -e

: ${WPENGINE_SITE?Required environment variable not set.}
: ${WPENGINE_SSH_KEY_PRIVATE?Required secret not set.}
: ${WPENGINE_SSH_KEY_PUBLIC?Required secret not set.}

SSH_PATH="$HOME/.ssh"
WPENGINE_HOST="git.wpengine.com"
KNOWN_HOSTS_PATH="$SSH_PATH/known_hosts"
WPENGINE_SSH_KEY_PRIVATE_PATH="$SSH_PATH/wpengine_key"
WPENGINE_SSH_KEY_PUBLIC_PATH="$SSH_PATH/wpengine_key.pub"
WPENGINE_ENVIRONMENT_DEFAULT="production"
WPENGINE_ENV=${WPENGINE_ENVIRONMENT:-$WPENGINE_ENVIRONMENT_DEFAULT}

mkdir "$SSH_PATH"

ssh-keyscan -t rsa "$WPENGINE_HOST" >> "$KNOWN_HOSTS_PATH"

echo "$WPENGINE_SSH_KEY_PRIVATE" > "$WPENGINE_SSH_KEY_PRIVATE_PATH"
echo "$WPENGINE_SSH_KEY_PUBLIC" > "$WPENGINE_SSH_KEY_PUBLIC_PATH"

chmod 700 "$SSH_PATH"
chmod 644 "$KNOWN_HOSTS_PATH"
chmod 600 "$DEPLOY_KEY"
chmod 644 "$DEPLOY_KEY_PUB"

git config core.sshCommand "ssh -i $WPENGINE_SSH_KEY_PRIVATE_PATH -o UserKnownHostsFile=$KNOWN_HOSTS_PATH"
git remote add $WPENGINE_ENV git@$WPENGINE_HOST:$WPENGINE_ENV/$WPENGINE_SITE.git
git push -f $WPENGINE_ENV master
