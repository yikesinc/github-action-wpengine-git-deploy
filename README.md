# Yikes WP Engine Deploy

An action to deploy your repository to a **[WP Engine](https://wpengine.com)** site via git. [Read more](https://wpengine.com/git/) about WP Engine's git deployment support.

Original action forked from @campaignupgrade who forked from @jovrtn! Thanks y'all!

## Example Production Github Action Deploy

```
name: YIKES, Inc. CI Deploy Master

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v2
    - run: |
          git fetch --prune --unshallow

    - name: GitHub Action for WP Engine Git Deployment
      uses: yikesinc/github-action-wpengine-git-deploy@master
      env:
        WPENGINE_SITE_NAME: 'yikesinc' # your wp engine site name. example: yikesinc.wpengine.com would be yikesinc
        LOCAL_BRANCH: 'master' # branch that you're pushing too on WP Engine.
        WP_ENGINE_ENV: 'production' # environment you're pushing too. Use this for staging on legacy staging.
        WPENGINE_SSH_KEY_PRIVATE: ${{ secrets.WPENGINE_SSH_KEY_PRIVATE }}
        WPENGINE_SSH_KEY_PUBLIC: ${{ secrets.WPENGINE_SSH_KEY_PUBLIC }}
```

## Example Legacy Staging Github Action Deploy

```
name: YIKES, Inc. CI Deploy Staging
# Controls when the action will run. Triggers the workflow on push or pull request
# events but only for the master branch
on:
  push:
    branches:
      - staging

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  build:
    runs-on: ubuntu-18.04
    steps:
    - uses: actions/checkout@v2
    - run: |
          git fetch --prune --unshallow

    - name: GitHub Action for WP Engine Git Deployment
      uses: yikesinc/github-action-wpengine-git-deploy@master
      env:
        WPENGINE_SITE_NAME: 'yikesinc'
        LOCAL_BRANCH: 'staging'
        WP_ENGINE_ENV: 'staging'
        WPENGINE_SSH_KEY_PRIVATE: ${{ secrets.WPENGINE_SSH_KEY_PRIVATE }}
        WPENGINE_SSH_KEY_PUBLIC: ${{ secrets.WPENGINE_SSH_KEY_PUBLIC }}
```

## Environment Variables & Secrets

### Required

| Name | Type | Usage |
|-|-|-|
| `WPENGINE_SITE_NAME` | Environment Variable | The name of the WP Engine site you want to deploy to. |
| `WPENGINE_SSH_KEY_PRIVATE` | Secret | Private SSH key of your WP Engine git deploy user. See below for SSH key usage. |
|  `WPENGINE_SSH_KEY_PUBLIC` | Secret | Public SSH key of your WP Engine git deploy user. See below for SSH key usage. |
| `WPENGINE_ENV` | Environment Variable  | Defaults to `production`. You shouldn't need to change this, but if you're using WP Engine's legacy staging, you can override the default and set to `staging` if needed. |
| `LOCAL_BRANCH` | Environment Variable  | Set which branch in your repository you'd like to push to WP Engine. Defaults to `master`. |

### Further reading

* [Defining environment variables in GitHub Actions](https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/#environment-variables)
* [Storing secrets in GitHub repositories](https://developer.github.com/actions/managing-workflows/storing-secrets/)

## Setting up your SSH keys

1. [Generate a new SSH key pair](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) as a special deploy key. The simplest method is to generate a key pair with a blank passphrase, which creates an unencrypted private key.
2. Store your public and private keys in your GitHub repository as new 'Secrets' (under your repository settings), using the names `WPENGINE_SSH_KEY_PRIVATE` and `WPENGINE_SSH_KEY_PUBLIC` respectively. In theory, this replaces the need for encryption on the key itself, since GitHub repository secrets are encrypted by default.
3. Add the public key to your target WP Engine environment.
4. Per the [WP Engine documentation](https://wpengine.com/git/), it takes about 30-45 minutes for the new SSH key to become active.
