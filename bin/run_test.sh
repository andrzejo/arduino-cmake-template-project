#!/usr/bin/env bash

set -eo pipefail

[[ "${TRACE}" ]] && set -x

readonly dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly rootDir="$(realpath "${dir}/..")"

readonly buildDir="${rootDir}/build-ci"
readonly htmlReportDir="${buildDir}/html"
readonly testResultDir="${rootDir}/build-ci/test/ctest/Testing"
readonly tagFilePath="${testResultDir}/TAG"
readonly xmlSchema="${rootDir}/test/report/ctest2junix.xsl"

export MAKE_TERMOUT=1
export CTEST_FULL_OUTPUT=1
export ASU_TEST_RESOURCE_PREFIX="${BUILD_URL}/execution/node/3/ws/build-ci/test/ctest/"

mkdir -p "${buildDir}"
cmake -DCMAKE_BUILD_TYPE=Debug -G "CodeBlocks - Unix Makefiles" -S "${rootDir}" -B "${buildDir}"
cmake --build "${buildDir}" --target test_run_all -- -j 3 || true

if [ -f "${tagFilePath}" ]; then
  readonly tag="$(cat "${tagFilePath}" | head -n 1)"
  readonly ctestReportXml="${testResultDir}/${tag}/Test.xml"
  readonly jUnitReportXml="${buildDir}/CTestResults.xml"

  saxon-xslt -xsl:"${xmlSchema}" -s:"${ctestReportXml}" -o:${jUnitReportXml}
  echo "Saved jUnit like xml report to '${jUnitReportXml}'"

  mkdir -p "${htmlReportDir}"

  cp -v "${jUnitReportXml}" "${htmlReportDir}"

  cp -rv "${rootDir}/build-ci/test/ctest/asu-reports" "${htmlReportDir}"
  cp -rv "${rootDir}/build-ci/test/ctest/asu-resources" "${htmlReportDir}"

  cp -rv "${rootDir}/test/report/html/public/index.html" "${htmlReportDir}"
  cp -rv "${rootDir}/test/report/html/public/icon.png" "${htmlReportDir}"
  cp -rv "${rootDir}/test/report/html/public/reportApp.js" "${htmlReportDir}"
else
  echo "Warning: Test tag file '${tagFilePath}' missing!"
fi
