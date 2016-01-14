#!/usr/bin/env bash

base=$(realpath $(dirname $0))
repo_base=$1

cd ${repo_base}/cf-release
./scripts/generate_deployment_manifest \
    warden \
    bosh-lite/stubs/dev-security-groups.yml \
    bosh-lite/stubs/property_overrides.yml \
    ${base}/director.yml \
    templates/cf-minimal-dev.yml \
    ${repo_base}/diego-release/stubs-for-cf-release/enable_diego_ssh_in_cf.yml \
    > ${base}/cf.yml


cd ${repo_base}/diego-release
./scripts/generate-deployment-manifest \
    -c ${base}/cf.yml \
    -i ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/iaas-settings.yml \
    -p ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/property-overrides.yml \
    -n ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/instance-count-overrides.yml \
    > ${base}/diego.yml
