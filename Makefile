####################################################################
#
#               C++ Library and Packages Example
#
####################################################################
#
# This Makefile is just a shortcut to cmake commands
# for make users (Linux-GCC, MacOS-clang or Windows-Rtools)
#
# Call 'make' with one of this target:
#
# Information:
#  - print_version  Display project name, version and date
# 
# C++ Library:
#  - shared         Build shared library
#  - static         Build static library
#  - doxygen        Build doxygen documentation [optional]
#  - install        Install shared library [and html doxymentation]
#  - uninstall      Uninstall shared library [and html doxymentation]
#
# Python wrapper (only for Linux-GCC or MacOS-clang):
#  - python_doc     Build python package documentation [optional]
#  - python_build   Build python wrapper [and its documentation]
#  - python_install Install python package [and its documentation]
#
# R wrapper:
#  - r_doc          Build R package documentation [optional]
#  - r_build        Build R wrapper [and its documentation]
#  - r_install      Install R package [and its documentation]
#
# Non-regression tests:
#  - build_tests    Build non-regression tests C++ executables
#  - check_cpp      Execute non-regression tests (C++)
#  - check_py       Execute non-regression tests (python)
#  - check_r        Execute non-regression tests (R)
#  - check          Execute non-regression tests (C++ + python + R)
#  - check_test     Execute a single test (set $TEST variable)
#
# Demonstration scripts:
#  - check_ipynb    Execute demonstration scripts (jupyter notebooks) and check output
#  - check_rmd      Execute demonstration scripts (R Markdown) and check output
#  - build_demos    Execute demonstration scripts (jupyter and R Markdown) and build HTMLs
#
# Clean:
#  - clean          Clean generated files
#  - clean_all      Clean the build directory
#
# You can use the following variables:
#
#  - DEBUG=1            Build the debug version of the library and tests (default =0)
#  - N_PROC=N           Use more CPUs for building procedure (default =1)
#  - BUILD_DIR=<path>   Define a specific build directory (default =build[_msys])
#  - BUILD_PYTHON=1     Configure cmake to build python wrapper (default =0, see target python_*)
#  - BUILD_R=1          Configure cmake to build R wrapper (default =0, see target r_*)
#  - TEST=<test-target> Name of the test target to be launched (e.g. test_Model_py)
#
# Usage example:
#
#  make check N_PROC=2
#

ifndef BUILD_PYTHON
  BUILD_PYTHON = 0
endif
ifeq ($(BUILD_PYTHON), 1)
  BUILD_PYTHON = ON
 else
  BUILD_PYTHON = OFF 
endif

ifndef BUILD_R
  BUILD_R = 0
endif
ifeq ($(BUILD_R), 1)
  BUILD_R = ON
 else
  BUILD_R = OFF 
endif

ifeq ($(OS),Windows_NT)
  # Assume MinGW (via RTools) => so MSYS Makefiles
  GENERATOR = -G"MSYS Makefiles"
else
  ifeq (, $(shell which ninja))
    # Standard GNU UNIX Makefiles otherwise
    GENERATOR = -G "Unix Makefiles"
  else
    # Standard GNU UNIX Makefiles otherwise
    GENERATOR = -G "Ninja"
  endif
  # Set OS also for Linux or Darwin
  OS := $(shell uname -s)
endif

ifeq ($(DEBUG), 1)
  BUILD_TYPE = Debug
 else
  BUILD_TYPE = Release 
endif

ifndef BUILD_DIR
  ifeq ($(OS),Windows_NT)
    # Assume MinGW (via RTools) => so MSYS build folder
    BUILD_DIR = build_msys
  else
    BUILD_DIR = build
  endif
endif

ifdef N_PROC
  ifeq ($(OS),Windows_NT)
    # Otherwise, tons of undefined references when compiling (don't know why)
    N_PROC_OPT = -j1 | tee /dev/null
  else
    N_PROC_OPT = -j$(N_PROC) | tee /dev/null
  endif
else
  N_PROC_OPT = -j1 | tee /dev/null
endif
# Add  "| tee /dev/null" because Ninja prints output in a signe line :
# https://stackoverflow.com/questions/46970462/how-to-enable-multiline-logs-instead-of-single-line-progress-logs


CMAKE_DEFINES = -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)

.PHONY: all cmake cmake-python cmake-r cmake-python-r cmake-doxygen cmake-python-doxygen cmake-r-doxygen cmake-python-r-doxygen print_version static shared build_tests doxygen install uninstall

all: shared install

cmake:
	@cmake -B$(BUILD_DIR) -S. $(GENERATOR) $(CMAKE_DEFINES) -DBUILD_PYTHON=$(BUILD_PYTHON) -DBUILD_R=$(BUILD_R)

cmake-python:
	@cmake -B$(BUILD_DIR) -S. $(GENERATOR) $(CMAKE_DEFINES) -DBUILD_PYTHON=ON              -DBUILD_R=$(BUILD_R)

cmake-r:
	@cmake -B$(BUILD_DIR) -S. $(GENERATOR) $(CMAKE_DEFINES) -DBUILD_PYTHON=$(BUILD_PYTHON) -DBUILD_R=ON

cmake-python-r:
	@cmake -B$(BUILD_DIR) -S. $(GENERATOR) $(CMAKE_DEFINES) -DBUILD_PYTHON=ON              -DBUILD_R=ON

cmake-doxygen:
	@cmake -B$(BUILD_DIR) -S. $(GENERATOR) $(CMAKE_DEFINES) -DBUILD_PYTHON=$(BUILD_PYTHON) -DBUILD_R=$(BUILD_R) -DBUILD_DOXYGEN=ON

cmake-python-doxygen:
	@cmake -B$(BUILD_DIR) -S. $(GENERATOR) $(CMAKE_DEFINES) -DBUILD_PYTHON=ON              -DBUILD_R=$(BUILD_R) -DBUILD_DOXYGEN=ON

cmake-r-doxygen:
	@cmake -B$(BUILD_DIR) -S. $(GENERATOR) $(CMAKE_DEFINES) -DBUILD_PYTHON=$(BUILD_PYTHON) -DBUILD_R=ON         -DBUILD_DOXYGEN=ON

cmake-python-r-doxygen:
	@cmake -B$(BUILD_DIR) -S. $(GENERATOR) $(CMAKE_DEFINES) -DBUILD_PYTHON=ON              -DBUILD_R=ON         -DBUILD_DOXYGEN=ON

print_version: cmake
	@cmake --build $(BUILD_DIR) --target print_version --

static shared build_tests install uninstall: cmake-doxygen
	@cmake --build $(BUILD_DIR) --target $@ -- $(N_PROC_OPT)



.PHONY: python_doc python_build python_install

python_doc: cmake-python-doxygen
	@cmake --build $(BUILD_DIR) --target python_doc -- $(N_PROC_OPT)

python_build: cmake-python
	@cmake --build $(BUILD_DIR) --target python_build -- $(N_PROC_OPT)

python_install: cmake-python
	@cmake --build $(BUILD_DIR) --target python_install -- $(N_PROC_OPT)


.PHONY: r_doc r_build r_install

r_doc: cmake-r-doxygen
	@cmake --build $(BUILD_DIR) --target r_doc -- $(N_PROC_OPT)

r_build: cmake-r
	@cmake --build $(BUILD_DIR) --target r_build -- $(N_PROC_OPT)

r_install: r_build
	@cmake --build $(BUILD_DIR) --target r_install -- $(N_PROC_OPT)


.PHONY: check_cpp check_py check_r check check_ipynb check_rmd check_test build_demos

check_cpp: cmake
	@CTEST_OUTPUT_ON_FAILURE=1 cmake --build $(BUILD_DIR) --target check_cpp -- $(N_PROC_OPT)

check_py: cmake-python
	@CTEST_OUTPUT_ON_FAILURE=1 cmake --build $(BUILD_DIR) --target check_py -- $(N_PROC_OPT)

check_r: cmake-r
	@CTEST_OUTPUT_ON_FAILURE=1 cmake --build $(BUILD_DIR) --target check_r -- $(N_PROC_OPT)

check: cmake-python-r-doxygen
	@CTEST_OUTPUT_ON_FAILURE=1 cmake --build $(BUILD_DIR) --target check -- $(N_PROC_OPT)

check_ipynb: cmake-python-doxygen
	@CTEST_OUTPUT_ON_FAILURE=1 cmake --build $(BUILD_DIR) --target check_ipynb -- $(N_PROC_OPT)

check_rmd: cmake-r-doxygen
	@CTEST_OUTPUT_ON_FAILURE=1 cmake --build $(BUILD_DIR) --target check_rmd -- $(N_PROC_OPT)

check_test: cmake-python-r
	@cd $(BUILD_DIR); CTEST_OUTPUT_ON_FAILURE=1 ctest -R $(TEST)

build_demos: cmake-python-r-doxygen
	@cmake --build $(BUILD_DIR) --target build_demos -- $(N_PROC_OPT)

.PHONY: clean clean_all

clean: 
	@cmake --build $(BUILD_DIR) --target clean -- $(N_PROC_OPT)

clean_all:
	@rm -rf $(BUILD_DIR)

