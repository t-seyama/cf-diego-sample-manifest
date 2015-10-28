#!/usr/bin/env bash

base=$(realpath $(dirname $0))
repo_base=$1

cd ${repo_base}/cf-release
./scripts/generate_deployment_manifest warden \
    ${base}/director.yml \
    ${repo_base}/diego-release/stubs-for-cf-release/enable_consul_with_cf.yml \
    ${repo_base}/diego-release/stubs-for-cf-release/enable_diego_ssh_in_cc.yml \
    > ${base}/cf.yml


cd ${repo_base}/diego-release
./scripts/generate-deployment-manifest \
    ${base}/director.yml \
    ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/property-overrides.yml \
    ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/instance-count-overrides.yml \
    ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/persistent-disk-overrides.yml \
    ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/iaas-settings.yml \
    ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/additional-jobs.yml \
    ${base} \
    > ${base}/diego.yml
