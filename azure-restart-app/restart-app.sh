#!/bin/sh

# required environment variables:

# REVISION=""
RESOURCE_GROUP="ds24-resources"
# PUBLIC_URL=""       # the public url associated with the container app
# AZURE_TENANT_ID=""  # you can get this by doing `az account show` when logged in with your
# AZURE_APP_ID=""     # this is the "username" of the limited rights account to use
# AZURE_PASSWORD=""

# Azure authentication
az login --service-principal -u "$AZURE_APP_ID" -p "$AZURE_PASSWORD" --tenant "$AZURE_TENANT_ID" > /dev/null

# request container app revision information
APP_STATE=$(az containerapp revision show --revision "$REVISION" -g "$RESOURCE_GROUP")

# determine the number of active replicas
ORIGINAL_REPLICA_COUNT=$(echo "$APP_STATE" | jq --args '.properties.replicas')

if [ "$ORIGINAL_REPLICA_COUNT" -eq 0 ]; then
    # if there are no active replicas, we can cheat a little and just call the public URL to trigger the launch of a replica
    echo "Container starting..."
    curl -q "$PUBLIC_URL"
    echo "Container started"
else
    # if there are already active replicas, we need the az cli to request a restart
    az containerapp revision restart --revision "$REVISION" -g "$RESOURCE_GROUP" > /dev/null
    echo "Container restarting..."

    # monitor the active replicas (they will increase during restart)
    APP_STATE=$(az containerapp revision show --revision "$REVISION" -g "$RESOURCE_GROUP")
    BUSY_REPLICA_COUNT=$(echo "$APP_STATE" | jq --args '.properties.replicas')

    # wait until the number of replicas settles back down to what we initially began with
    while [ "$BUSY_REPLICA_COUNT" -ne "$ORIGINAL_REPLICA_COUNT" ]; do
        sleep 5
        APP_STATE=$(az containerapp revision show --revision "$REVISION" -g "$RESOURCE_GROUP")
        BUSY_REPLICA_COUNT=$(echo "$APP_STATE" | jq --args '.properties.replicas')
        if [ "$BUSY_REPLICA_COUNT" -eq 0 ]; then
            # in case something went wrong, try to trigger a launch as a last resort
            echo "Container starting..."
            curl -q "$PUBLIC_URL"
            echo "Container started"
            exit
        fi
        echo "Waiting"
    done

    echo "Has restarted"
fi
