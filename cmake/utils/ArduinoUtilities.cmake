set(DEPENDENCY_LIBS_DIR ${CMAKE_SOURCE_DIR}/vendor/libs)

include(${CMAKE_SOURCE_DIR}/GitVersionsLock.cmake OPTIONAL)

function(get_list_of_variables _prefix _varResult)
    get_cmake_property(_vars VARIABLES)
    string(REGEX MATCHALL "(^|;)${_prefix}[a-zA-Z0-9_-]*" _matchedVars "${_vars}")
    set(${_varResult} ${_matchedVars} PARENT_SCOPE)
endfunction()

function(get_git_dep_version _name _result)
    set(${_result} ${git_dep_version_${_name}} PARENT_SCOPE)
endfunction()

macro(save_git_version _name _version)
    set(git_dep_version_${_name} ${_version})
    get_list_of_variables(git_dep_version_ versions)
    set(_contents "")
    foreach (_var IN LISTS versions)
        set(_contents "${_contents}set(\"${_var}\" \"${${_var}}\")\n")
    endforeach ()
    file(WRITE "${CMAKE_SOURCE_DIR}/GitVersionsLock.cmake" ${_contents})
endmacro()

#
# download dependency (library) and link it
#
macro(add_arduino_git_dependency _target _name _url)
    set(_branch ${ARGV3})
    message("Add library: ${_name} ${_url}")
    file(MAKE_DIRECTORY ${DEPENDENCY_LIBS_DIR})

    get_git_dep_version(${_name} _ver)
    if (NOT _ver)
        set(_ver ${_branch})
    endif ()

    git_clone(
            PROJECT_NAME ${_name}
            GIT_URL ${_url}
            DIRECTORY ${DEPENDENCY_LIBS_DIR}
            GIT_BRANCH ${_ver}
    )

    get_git_commit("${DEPENDENCY_LIBS_DIR}/${_name}" _commit)
    save_git_version("${_name}" "${_commit}")

    link_existing_library(${_target} ${_name})
endmacro()

#
# configure existing library to link
# keys: SUBDIRECTORIES - add subdirectories as separate libraries
#
macro(configure_existing_library _library_dir _key _value)
    set(EXISTING_LIBRARY_CONFIG_${_library_dir}_${_key} ${_value})
    message("Configure library ${_library_dir} - set ${_key} = ${_value}")
endmacro()

#
# link existing library
#
macro(link_existing_library _target _name)
    set(_path ${ARGV2})

    set(_subdirs ${EXISTING_LIBRARY_CONFIG_${_name}_SUBDIRECTORIES})
    if (_subdirs)
        foreach (_sub_dir_name IN LISTS _subdirs)
            message("${_name} library: create library from subdirectory '${_sub_dir_name}'")
            link_existing_library(${_target} "${_name}_${_sub_dir_name}" "${DEPENDENCY_LIBS_DIR}/${_name}/${_sub_dir_name}")
        endforeach ()
    else ()
        file(GLOB ALL_LIBS_DIR LIST_DIRECTORIES true "${DEPENDENCY_LIBS_DIR}/*")
        foreach (_dir_name IN LISTS ALL_LIBS_DIR)
            get_filename_component(_lib_name "${_dir_name}" NAME)
            set(_dir_subdirs ${EXISTING_LIBRARY_CONFIG_${_lib_name}_SUBDIRECTORIES})
            if (_dir_subdirs)
                foreach (_sub_dir_name IN LISTS _dir_subdirs)
                    set(_inc_dir "${_dir_name}/${_sub_dir_name}")
                    message("${_name} library: add include directory '${_inc_dir}'")
                    list(APPEND ALL_LIBS_DIR "${_inc_dir}")
                endforeach ()
            endif ()
        endforeach ()
        set(_prefixed_name ${_name}_lib)

        if (NOT _path)
            set(_path "${DEPENDENCY_LIBS_DIR}/${_name}")
        endif ()

        target_include_directories(${_target} PRIVATE "${ALL_LIBS_DIR}")
        add_custom_arduino_library(${_prefixed_name} ${_name} PATH "${_path}")
        target_include_directories(${_prefixed_name} PRIVATE "${ALL_LIBS_DIR}")
        target_link_arduino_libraries(${_prefixed_name} AUTO_PRIVATE)
        target_link_arduino_libraries(${_target} PRIVATE ${_prefixed_name})
    endif ()
endmacro()

#
# get git commit
#
function(get_git_commit _dir _ret_var)
    find_package(Git)
    if (NOT GIT_FOUND)
        message(FATAL_ERROR "git not found!")
    endif ()

    if (NOT _dir)
        message(FATAL_ERROR "You must provide a destination dir")
    endif ()

    if (EXISTS ${_dir})
        execute_process(
                COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
                WORKING_DIRECTORY ${_dir}
                OUTPUT_VARIABLE git_output
                ERROR_VARIABLE git_output
                RESULT_VARIABLE ret)
        if (NOT ret EQUAL "0")
            message(FATAL_ERROR "Invalid exit status: '${ret}'")
        else ()
            string(STRIP "${git_output}" git_output)
            set(${_ret_var} ${git_output} PARENT_SCOPE)
            message(STATUS "Directory ${_dir} version: ${${_ret_var}}.")
        endif ()
    else ()
        message(STATUS "Directory ${_dir} does not exists.")
    endif ()

endfunction()

#
# clone GitHub repo to project
#
function(install_from_github _dir _name _url)
    find_package(Git)
    if (NOT GIT_FOUND)
        message(FATAL_ERROR "git not found!")
    endif ()

    if (NOT _dir)
        message(FATAL_ERROR "You must provide a destination dir")
    endif ()

    if (NOT _url)
        message(FATAL_ERROR "You must provide a git url")
    endif ()

    if (NOT _name)
        message(FATAL_ERROR "You must provide a repo dest name")
    endif ()

    file(MAKE_DIRECTORY ${_dir})
    set(path "${_dir}/${_name}")
    if (EXISTS ${path})
        message(STATUS "Directory ${path} exists. Skipping.")
    else ()
        message(STATUS "Directory ${path} does not exists. Clone repo ${_url}.")
        execute_process(
                COMMAND ${GIT_EXECUTABLE} clone ${_url} ${path} --recursive
                WORKING_DIRECTORY ${_dir}
                OUTPUT_VARIABLE git_output
                ERROR_VARIABLE git_output
                RESULT_VARIABLE ret)
        if (NOT ret EQUAL "0")
            message(FATAL_ERROR "Invalid exit status: '${ret}'")
        else ()
            message(STATUS ${git_output})
        endif ()
    endif ()

    get_git_dep_version(${_name} _ver)
    if (${_ver})
        execute_process(
                COMMAND ${GIT_EXECUTABLE} checkout ${_ver}
                WORKING_DIRECTORY ${_dir}
                OUTPUT_VARIABLE git_output
                ERROR_VARIABLE git_output
                RESULT_VARIABLE ret)
        if (NOT ret EQUAL "0")
            message(FATAL_ERROR "Invalid exit status: '${ret}'")
        else ()
            message(STATUS ${git_output})
        endif ()
    endif ()
    get_git_commit("${path}" _commit)
    save_git_version("${_name}" "${_commit}")

endfunction()

function(dump_cmake_variables)
    get_cmake_property(_variableNames VARIABLES)
    list(SORT _variableNames)
    foreach (_variableName ${_variableNames})
        if (ARGV0)
            unset(MATCHED)
            string(REGEX MATCH ${ARGV0} MATCHED ${_variableName})
            if (NOT MATCHED)
                continue()
            endif ()
        endif ()
        message(STATUS "${_variableName}=${${_variableName}}")
    endforeach ()
endfunction()