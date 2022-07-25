cmake_minimum_required(VERSION 3.16)

set(PROJECT_NAME template-project)

include(${CMAKE_SOURCE_DIR}/Dependencies.cmake)

project(${PROJECT_NAME} CXX)

file(GLOB_RECURSE ALL_SOURCES "src/*.h" "src/*.cpp")
add_executable(${PROJECT_NAME} ${ALL_SOURCES} ${VERSION_FILE})

target_link_arduino_libraries(${PROJECT_NAME} PRIVATE core Wire SPI)

#example libraries
add_arduino_git_dependency(${PROJECT_NAME} uRTCLib "https://github.com/Naguissa/uRTCLib.git")
add_arduino_git_dependency(${PROJECT_NAME} ACS712CurrentSensor "https://github.com/rkoptev/ACS712-arduino.git")

# This is needed for the generation of HEX binary and uploading it
target_enable_arduino_upload(${PROJECT_NAME})

include(${CMAKE_SOURCE_DIR}/Version.cmake)

enable_testing()
add_subdirectory(test/ctest)
