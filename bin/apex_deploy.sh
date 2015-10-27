#!/bin/bash
# Args:
#   1. filepath e.g src/pages/SendEmail.page
#   2. tooling-force jar filepath
#   3. .properties config filepath

echo -e "$1\n$1-meta.xml" > /tmp/currentFile
java -jar $2
        \ --action=deploySpecificFiles
        \ --config=$3
        \ --projectPath=$2
        \ --responseFilePath=/tmp/responseFile
        \ --specificFiles=/tmp/currentFile
        \ --ignoreConflicts=true
        \ --pollWaitMillis=1000'
