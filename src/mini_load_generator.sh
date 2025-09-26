#!/bin/sh

while :
do
    curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" https://otel-cloud-run-demo-161156519703.us-central1.run.app/?n=37
    sleep 1
done
