#!/bin/bash
# Args:
#   1. target filepath relative to project e.g src/pages/SendEmail.page
#   2. tooling-force jar filepath
#   3. .properties config filepath
#   4. project filepath

echo -e "$1\n$1-meta.xml" > /tmp/currentFile
java -jar $2 --action=deploySpecificFiles \
             --config=$3 \
             --projectPath=$4 \
             --responseFilePath=/tmp/responseFile \
             --specificFiles=/tmp/currentFile \
             --ignoreConflicts=true \
             --pollWaitMillis=1000
