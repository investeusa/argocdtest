#!/bin/bash
curl -sfL https://get.k3s.io | K3S_URL=https://PRIVATE_MASTER_IP:6443 K3S_TOKEN=TOKEN_MASTER sh -