#!/bin/bash

set -euxo pipefail

# additional preparations for test images

dnf in -y @guest-agents @guest-desktop-agents
