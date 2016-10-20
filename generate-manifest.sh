#!/usr/bin/env bash

base=$(realpath $(dirname $0))
repo_base=$1

cd ${repo_base}/cf-release
./scripts/generate_deployment_manifest \
    bosh-lite \
    <(echo "director_uuid: cf5f29da-51c9-433f-8c1f-9ae0536d4778") \
    > ${base}/cf.yml


cd ${repo_base}/diego-release
./scripts/generate-deployment-manifest \
        -c ${base}/cf.yml \
        -i ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/iaas-settings.yml \
        -p ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/property-overrides.yml \
        -n ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/instance-count-overrides.yml \
        -v ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/release-versions.yml \
        -s ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/postgres/diego-sql.yml \
        -x \
        -d ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/experimental/voldriver/drivers.yml \
        -b \
        -g \
        > ${base}/diego.yml
