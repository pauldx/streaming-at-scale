#!/bin/bash

# Strict mode, fail on any error
set -euo pipefail

source ../streaming/databricks/runners/verify-common.sh

source ../streaming/databricks/job/run-databricks-job.sh verify-kafka true "$(cat <<JQ
  .notebook_task.base_parameters."test-output-path" = "$DATABRICKS_TESTOUTPUTPATH"
  | .notebook_task.base_parameters."kafka-servers" = "$KAFKA_BROKERS"
  | .notebook_task.base_parameters."kafka-topics" = "$KAFKA_OUT_TOPIC"
  | .notebook_task.base_parameters."assert-events-per-second" = "$(($TESTTYPE * 900))"
  | .notebook_task.base_parameters."assert-duplicate-fraction" = "$ALLOW_DUPLICATE_FRACTION"
  | .notebook_task.base_parameters."assert-outofsequence-fraction" = "$ALLOW_OUTOFSEQUENCE_FRACTION"
JQ
)"

source ../streaming/databricks/runners/verify-download-result.sh
