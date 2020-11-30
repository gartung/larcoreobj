# ======================================================================
#  larcoreobj main build file
#
#  cd .../path/to/build/directory
#  source .../path/to/larcoreobj/ups/setup_for_development <-d|-p>
#  buildtool [-I /install/path] -bt[i] -jN
# ======================================================================
# use cmake 3.14 or later
cmake_minimum_required(VERSION 3.18.2 FATAL_ERROR)
cmake_policy(VERSION 3.14)
# Policy CMP0096 must be set to NEW to preserve leading zeros in the
# VERSION set by project().
cmake_policy(SET CMP0096 NEW)



find_package(cetmodules 2.05.03 REQUIRED)
project(larcoreobj VERSION 09.00.00 LANGUAGES CXX)

include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS CAUTIOUS
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic -Wno-unused-local-typedefs
)

cet_report_compiler_flags(REPORT_THRESHOLD VERBOSE)

# these are minimum required versions, not the actual product versions
find_package( canvas REQUIRED )
find_package( ROOT REQUIRED )

# macros for artdaq_dictionary and simple_plugin
include(ArtDictionary)
include(CetMake)
include(BasicPlugin)

# source
add_subdirectory(larcoreobj)

# tests
add_subdirectory(test)

# ups - table and config files

# packaging utility
cet_cmake_config(COMPATIBILITY SameMajorVersion)
