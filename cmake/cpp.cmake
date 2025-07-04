# Make Release version the default (only for single configuration generators)
# TODO : Differentiate build directories for Debug and Release
if(NOT IS_MULTI_CONFIG)
  if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "Setting build type to 'Release' as none was specified")
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
    # Set the possible values of build type for cmake-gui
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
  endif()
  # Show current configuration
  message(STATUS "BUILD_TYPE=" ${CMAKE_BUILD_TYPE})
endif()

# Add c++11 support whatever the compiler
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Warning fiesta!
# https://cmake.org/cmake/help/latest/command/add_compile_options.html
if (MSVC)
  # Warning level 4 (4 = maximum, 0 = none)
  add_compile_options(/W4 /wd4251 /wd4244) # Except those two warnings
  # Silence MSVC warnings about unsafe C standard library functions
  add_compile_definitions(_CRT_SECURE_NO_WARNINGS)
else()
  # Lots of warnings (-Wall = add some warnings, -Wextra = add a ton of warnings)
  add_compile_options(-Wall -Wextra)
endif()

# C++ header location (keep the trailing '/')
set(INCLUDES 
    ${PROJECT_SOURCE_DIR}/include/)
# C++ source path (prevent using GLOB)
set(SOURCES
    ${PROJECT_SOURCE_DIR}/src/fibo.cpp
    ${PROJECT_SOURCE_DIR}/src/args.cpp
    ${PROJECT_SOURCE_DIR}/src/polymorph.cpp
    ${PROJECT_SOURCE_DIR}/src/stdoutredirect.cpp)

# Generation folder (into Release or Debug)
if (NOT IS_MULTI_CONFIG AND NOT WIN32)
  cmake_path(APPEND CMAKE_CURRENT_BINARY_DIR ${CMAKE_BUILD_TYPE} OUTPUT_VARIABLE CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  cmake_path(APPEND CMAKE_CURRENT_BINARY_DIR ${CMAKE_BUILD_TYPE} OUTPUT_VARIABLE CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  cmake_path(APPEND CMAKE_CURRENT_BINARY_DIR ${CMAKE_BUILD_TYPE} OUTPUT_VARIABLE CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
endif()

# Shared and Static libraries
add_library(shared                  SHARED ${SOURCES})
add_library(static EXCLUDE_FROM_ALL STATIC ${SOURCES})
set(FLAVORS shared static)

############################## Loop on flavors: shared and static
foreach(FLAVOR ${FLAVORS})
  # Convert flavor to uppercase
  string(TOUPPER ${FLAVOR} FLAVOR_UP)

  # Alias target for a better name
  add_library(${PROJECT_NAME}::${FLAVOR} ALIAS ${FLAVOR})

  # Include directories
  # PUBLIC is mandatory for tests and packages (no need to install)
  target_include_directories(${FLAVOR} PUBLIC
    # Add includes path for compiling the library
    "$<BUILD_INTERFACE:${INCLUDES}>"
    # Add binary directory to find generated version.h and export.hpp
    "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}>"
  )

  # Set some target properties
  set_target_properties(${FLAVOR} PROPERTIES
    # Hide all symbols by default (impose same behavior between Linux and Windows)
    C_VISIBILITY_PRESET hidden
    CXX_VISIBILITY_PRESET hidden
    # Any client who links the library needs -fPIC (static or shared)
    POSITION_INDEPENDENT_CODE 1
  )

  # Rename the output library name
  set_target_properties(${FLAVOR} PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
  # append a 'd' to the output file name of the debug build targets
  set_target_properties(${FLAVOR} PROPERTIES DEBUG_POSTFIX "d")
  
  # Set library version
  set_target_properties(${FLAVOR} PROPERTIES VERSION ${PROJECT_FULL_VERSION})

  # Build a cmake file to be imported by library users
  export(TARGETS ${FLAVOR}
         NAMESPACE ${PROJECT_NAME}::
         FILE ${SWIGEX_CMAKE_FILE}
         APPEND)
         
endforeach(FLAVOR ${FLAVORS})
############################## End loop on flavors


###################### Shared library specific options

# Generate export header
include(GenerateExportHeader)
set(DISABLE_EXPORT_IF_SWIG "
#ifdef SWIG
#    undef ${PROJECT_NAME_UP}_EXPORT
#    undef ${PROJECT_NAME_UP}_NO_EXPORT
#    define ${PROJECT_NAME_UP}_EXPORT
#    define ${PROJECT_NAME_UP}_NO_EXPORT
#endif
#ifdef ${PROJECT_NAME_UP}_STATIC_DEFINE
#    define ${PROJECT_NAME_UP}_TEMPLATE_EXPORT
#else
#    ifdef shared_EXPORTS
#        define ${PROJECT_NAME_UP}_TEMPLATE_EXPORT
#    else
#        define ${PROJECT_NAME_UP}_TEMPLATE_EXPORT extern
#    endif
#endif
")
generate_export_header(shared
  BASE_NAME ${PROJECT_NAME}
  EXPORT_FILE_NAME ${CMAKE_BINARY_DIR}/${PROJECT_NAME}_export.hpp
  CUSTOM_CONTENT_FROM_VARIABLE DISABLE_EXPORT_IF_SWIG
)

# Set the so version to project major version
set_target_properties(shared PROPERTIES
  SOVERSION ${PROJECT_VERSION_MAJOR}
)

###################### Static library specific options

# Prevent from using _declspec when static
set_target_properties(static PROPERTIES
  COMPILE_FLAGS -D${PROJECT_NAME_UP}_STATIC_DEFINE
)
