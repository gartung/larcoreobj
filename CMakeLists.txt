# ======================================================================
#  larcoreobj main build file
#
#  cd .../path/to/build/directory
#  source .../path/to/larcoreobj/ups/setup_for_development <-d|-p>
#  cmake [-DCMAKE_INSTALL_PREFIX=/install/path]
#        -DCMAKE_BUILD_TYPE=$CETPKG_TYPE
#        $CETPKG_SOURCE
#  make
#  make test
#  make install
#  make package (builds distribution tarfile)
# ======================================================================


# use cmake 3.3 or later
cmake_minimum_required (VERSION 3.3)

project(larcoreobj VERSION 08.02.02 LANGUAGES CXX)

find_package(cetmodules)
include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS CAUTIOUS
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic -Wno-unused-local-typedefs
)

cet_report_compiler_flags()

# these are minimum required versions, not the actual product versions
find_package(canvas_root_io REQUIRED)


# macros for artdaq_dictionary and simple_plugin
include(ArtDictionary)
include(CetMake)
include(BasicPlugin)

# source
add_subdirectory(larcoreobj)

# tests 
add_subdirectory(test)

add_subdirectory(cmakeConfig)
