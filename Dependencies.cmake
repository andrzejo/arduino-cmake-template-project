include(${CMAKE_SOURCE_DIR}/cmake/utils/ArduinoUtilities.cmake)

install_from_github(${CMAKE_SOURCE_DIR}/vendor/cmake toolchain https://github.com/a9183756-gh/Arduino-CMake-Toolchain.git)
install_from_github(${CMAKE_SOURCE_DIR}/vendor/cmake git-utils https://github.com/andrzejo/cmake_git_clone)

include(${CMAKE_SOURCE_DIR}/vendor/cmake/git-utils/cmake/GitUtils.cmake)

include(${CMAKE_SOURCE_DIR}/BoardOptions.cmake)

set(ARDUINO_BOARD_OPTIONS_FILE ${CMAKE_SOURCE_DIR}/BoardOptions.cmake)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/vendor/cmake/toolchain/Arduino-toolchain.cmake)
