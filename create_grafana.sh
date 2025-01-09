#!/bin/bash

# Create directory structure
mkdir -p apps/base/monitoring/grafana
mkdir -p apps/staging/monitoring/grafana
mkdir -p clusters/staging

# Create base files
touch apps/base/monitoring/grafana/kustomization.yaml
touch apps/base/monitoring/grafana/release.yaml
touch apps/base/monitoring/grafana/namespace.yaml

# Create staging files
touch apps/staging/monitoring/grafana/kustomization.yaml
touch apps/staging/monitoring/grafana/cloudflare.yaml
