#!/bin/sh
helm repo add akri-helm-charts https://project-akri.github.io/akri/
helm upgrade --install akri akri-helm-charts/akri   --set agent.full=true
