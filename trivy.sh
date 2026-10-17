#!/usr/bin/env bash
mkdir -p logstrivy
trivy image --severity CRITICAL,HIGH iris-infer:naive > ./logstrivy/trivy-naive.log
trivy image --severity CRITICAL,HIGH iris-infer:opt > ./logstrivy/trivy-opt.log
trivy config . > ./logstrivy/trivy-config.log
