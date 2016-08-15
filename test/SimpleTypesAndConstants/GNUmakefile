#
# This is an example GNUmakefile for my packages
#

# specific names for this package
DICT  = larcoreobj_SimpleTypesAndConstantsTestDict
SHLIB = liblarcoreobj_SimpleTypesAndConstantsTestDict.so
SOURCES = $(filter-out geo_types_test.cc $(DICT).cxx, $(wildcard *.cxx))
FMWK_HEADERS = LinkDef.h $(DICT).h classes.h
HEADERS = $(filter-out $(FMWK_HEADERS), $(wildcard *.h))
OBJECTS = $(SOURCES:.cxx=.o)

# include options for this package
INCFLAGS  = -I.
INCFLAGS += -I$(LARLITE_USERDEVDIR)/larcoreobj/
#INCFLAGS += -I$(LARLITE_USERDEVDIR)
#INCLUDE_DIRS += $(LARLITE_USERDEVDIR)/larcoreobj/
#VPATH = $(LARLITE_USERDEVDIR)/larcoreobj/

# platform-specific options
OSNAME          = $(shell uname -s)
HOST            = $(shell uname -n)
OSNAMEMODE      = $(OSNAME)

include $(LARLITE_BASEDIR)/Makefile/Makefile.${OSNAME}

# set CINT flag
CINTFLAGS += -p

#CXXFLAGS := -std=c++11 -I$(BOOST_ROOT)
#LDFLAGS := -L$(BOOST_ROOT)/stage/lib -lboost_filesystem

# call the common GNUmakefile
LDFLAGS += $(shell larlite-config --libs)
LDFLAGS += -L$(LARLITE_LIBDIR) -llarcoreobj_SimpleTypesAndConstants
include $(LARLITE_BASEDIR)/Makefile/GNUmakefile.CORE



