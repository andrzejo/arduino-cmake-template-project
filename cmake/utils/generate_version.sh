#!/bin/bash

set -eo pipefail

[[ "${TRACE}" ]] && set -x

readonly grn='\033[0;32m'
readonly red='\033[0;31m'
readonly bld='\e[1m'
readonly nc='\033[0m'

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly versionFile="${1}"
readonly buildFile="${2}"
readonly tplFile="${dir}/_generated_version_tpl.h"

readonly lastBuild=$(tr -d "\n" < "${buildFile}")
readonly build=$((lastBuild+1))
readonly buildDate=$(date +"%y%m%d.%H%M%S")
echo -n "${build}" > "${buildFile}"
echo -e "Build number: ${grn}${build}${nc}"
echo -e "Build date  : ${grn}${buildDate}${nc}"

cat "${tplFile}" | \
  sed s/__BUILD__/${build}/ | \
  sed s/__TIMESTAMP__/${buildDate}/ \
  > "${versionFile}"
