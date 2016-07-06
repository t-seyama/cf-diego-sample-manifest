#!/usr/bin/env bash

base=$(realpath $(dirname $0))
repo_base=$1

cd ${repo_base}/cf-release
./scripts/generate_deployment_manifest \
    bosh-lite \
    <(echo "director_uuid: cf5f29da-51c9-433f-8c1f-9ae0536d4778") \
    > ${base}/cf.yml


cd ${repo_base}/diego-release
USE_SQL='mysql' ./scripts/generate-bosh-lite-manifests \
    -c ${base}/cf.yml \
    -i ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/iaas-settings.yml \
    -p ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/property-overrides.yml \
    -n ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/instance-count-overrides.yml \
    > ${base}/diego.yml

sql_option="-s manifest-generation/bosh-lite-stubs/experimental/mysql/diego-sql.yml"

./scripts/generate-deployment-manifest \
        -c ${base}/cf.yml \
        -i ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/iaas-settings.yml \
        -p ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/property-overrides.yml \
        -n ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/instance-count-overrides.yml \
        ${sql_option} \
        ${voldriver_option} \
        -v ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/release-versions.yml \
        > ${base}/diego.yml

tmpdir=$(mktemp -d /tmp/diego-manifest.XXXXX)

spiff merge \
        ${repo_base}/diego-release/manifest-generation/config-from-cf.yml \
        ${repo_base}/diego-release/manifest-generation/config-from-cf-internal.yml \
        ${base}/cf.yml \
        > ${tmpdir}/config-from-cf.yml

./scripts/generate-benchmarks-manifest \
        ${base}/diego.yml \
        ${repo_base}/diego-release/manifest-generation/benchmark-errand-stubs/default_bosh_lite_benchmark_properties.yml \
        ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/iaas-settings.yml \
        > ${base}/diego-benchmarks.yml

./scripts/generate-vizzini-manifest \
        -c ${base}/cf.yml \
        -p ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/vizzini-properties.yml \
        -i ${repo_base}/diego-release/manifest-generation/bosh-lite-stubs/iaas-settings.yml \
        > ${base}/vizzini.yml
