#!/usr/bin/env bash
set -x

# This file is subject to the terms and conditions defined in file 'LICENSE',
# which is part of this repository.

# Available environment variables
#
# ARA_CONFIG
# ARA_DATABASE
# ARA_DIR
# ARA_HOST
# ARA_LOG_FILE
# ARA_PORT

# Set default values

ARA_HOST=${ARA_HOST:-0.0.0.0}
ARA_PORT=${ARA_PORT:-9191}
export ARA_DATABASE=${ARA_DATABASE:-sqlite:////ara/ara.sqlite}
export ARA_DIR=${ARA_DIR:-/ara}
export ARA_LOG_FILE=${ARA_LOG_FILE:-/ara/ara.log}

if [[ ! -z $ARA_CONFIG ]]; then
    export ARA_CONFIG
fi

ara-manage runserver -p $ARA_PORT -h $ARA_HOST --threaded
