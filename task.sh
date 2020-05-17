#!/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SCRIPTS_DIR=$PROJECT_DIR/choco-scripts

$SCRIPTS_DIR/task.sh $@
