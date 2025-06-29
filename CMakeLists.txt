##########################################################################################
#
#                      SWIGEX C++ Library and Wrappers
#
#                   Author: Fabien Ors (MINES Paris - PSL) 
#                   License: MIT
#                   Date: May 2025
#
#
# 1. Configure project :
#
#    C/C++ only:       cmake -Bbuild -S.
#    Python:           cmake -Bbuild -S. -DBUILD_PYTHON=ON
#    R:                cmake -Bbuild -S. -DBUILD_R=ON
#
#
# 2a. Build static library (and install Python package)
# 
#   GCC / MinGW =>     cmake --build build --target python_install
#   MSVC        =>     cmake --build build --target python_install --config Release
#
#
# 2b. Build and install shared library (and don't build Python package)
#
#   GCC / MinGW =>     cmake --build build --target install
#   MSVC        =>     cmake --build build --target install --config Release
#
#
# 3. Execute non-regression tests (C++, Python and R)
#
#   GCC / MinGW =>     cmake --build build --target check
#   MSVC        =>     cmake --build build --target check --config Release
#
#
# Note: See shortcuts for 'make' users in Makefile file
#

# For recent UseSWIG
cmake_minimum_required(VERSION 3.20)

# Define project here
project(swigex
        VERSION      0.2.5
        DESCRIPTION  "C++ library and SWIG wrappers (R & Python)"
        HOMEPAGE_URL "https://github.com/fabien-ors/swigex"
        LANGUAGES    C CXX) # Enable C language for third party libraries
#set (PROJECT_VERSION_SUFFIX )   # Release
#set (PROJECT_VERSION_SUFFIX a1)  # Alpha1
#set (PROJECT_VERSION_SUFFIX b1)  # Beta1
set (PROJECT_VERSION_SUFFIX rc1) # Release Candidate1

# Build the full version
set (PROJECT_FULL_VERSION "${PROJECT_VERSION}${PROJECT_VERSION_SUFFIX}")

####################################################
## CONFIGURATION

# Extract Git commit timestamp, hash
find_package(Git)
execute_process(
  COMMAND ${GIT_EXECUTABLE} show -s --format=%ci
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  OUTPUT_VARIABLE ${PROJECT_NAME}_DATE
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
execute_process(
  COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  OUTPUT_VARIABLE ${PROJECT_NAME}_COMMIT
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Convert project name to uppercase
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UP)

# Fix version.h automatically
configure_file(version.h.in version.h)

# Detect presence of multi configuration generators
get_property(IS_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

# Activate verbose mode
#set(CMAKE_VERBOSE_MAKEFILE ON)
# Debug find package instruction
#set(CMAKE_FIND_DEBUG_MODE TRUE)

# Options
# By default, deactivate R and python packages
option(BUILD_PYTHON  "Build Python package"                     OFF)
option(BUILD_R       "Build R package"                          OFF)
option(BUILD_DOC     "Build Doxygen and packages documentation" OFF)
if (MINGW)
  set(BUILD_PYTHON OFF)
endif()
if (MSVC)
  set(BUILD_R OFF)
endif()
message(STATUS "BUILD_PYTHON="  ${BUILD_PYTHON})
message(STATUS "BUILD_R="       ${BUILD_R})
message(STATUS "BUILD_DOC="     ${BUILD_DOC})

# Create swigex cmake file path in the build tree
cmake_path(APPEND SWIGEX_CMAKE_FILE ${PROJECT_BINARY_DIR} "swigex.cmake")

####################################################
## BUILD & INSTALL

include(cmake/version.cmake)
include(cmake/cpp.cmake)
include(cmake/doxygen.cmake)
include(cmake/install.cmake)

####################################################
## PACKAGES

if(BUILD_PYTHON)
  add_subdirectory(python)
endif()

if(BUILD_R)
  add_subdirectory(r)
endif()

####################################################
## TESTING

# Add non-regression test target
include(CTest)
enable_testing()

add_subdirectory(tests)

####################################################
## DEMONSTRATION SCRIPTS

add_subdirectory(doc/demo)

