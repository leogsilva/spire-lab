#!/bin/bash

terraform output -json kubeconfig 2>/dev/null | jq -r . 