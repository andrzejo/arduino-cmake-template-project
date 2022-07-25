set(VERSION_FILE ${CMAKE_CURRENT_SOURCE_DIR}/src/version/_generated_version.h)
set(BUILD_FILE ${CMAKE_CURRENT_SOURCE_DIR}/_build_number)

add_custom_target(
        GenerateVersionFile
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/cmake/generate_version.sh "${VERSION_FILE}" "${BUILD_FILE}"
)

add_dependencies(upload-${PROJECT_NAME} GenerateVersionFile)
