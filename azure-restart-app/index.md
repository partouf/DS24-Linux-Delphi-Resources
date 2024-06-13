# Restart script

This script will restart your Container App.

## Requirements

Run `./install-requirements.sh` before using the restart script.

This will install the following:

* curl
* jq
* azure cli

## Creating a limited rights user for this script

* `az ad sp create-for-rbac`
  - Add the creditials to your secrets (AZURE_APP_ID, AZURE_PASSWORD)
* Log into Azure and go to your subscription
  - Select Access control (IAM)
  - Click Add and choose Add role assignment
  - Search for the role `ds24restartuserroledef` and select it
  - Go to Members and click Select members
  - Search for the created app name or search for `azure-cli` and select the one that has the current date
  - Confirm with Review and assign

## Getting AZ info

With a fully capable account you can request the following info:

* `az account show` will give you your `tenantId` to be used for `AZURE_TENANT_ID`
