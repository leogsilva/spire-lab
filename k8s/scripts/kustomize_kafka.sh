#!/bin/bash
set -x 
KUSTOMIZE_HOME=${PROJECT_HOME}/kustomize

function helmTemplate {
    helm template kafka ${PROJECT_HOME}/cp-helm-charts -f ${PROJECT_HOME}/cp-helm-charts-k3d/values.yaml > ${KUSTOMIZE_HOME}/base/all.yaml
}


function kustomizeIt {
    mkdir -p $HOME/kustomize/plugin || true
    XDG_CONFIG_HOME=${KUSTOMIZE_HOME}
    kustomize build --enable_alpha_plugins ${KUSTOMIZE_HOME}/$1
}

helmTemplate && kustomizeIt base
# kustomizeIt base