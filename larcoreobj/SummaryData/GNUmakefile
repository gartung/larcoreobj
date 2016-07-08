#
# This is an example GNUmakefile for my packages
#

# specific names for this package
DICT  = larcoreobj_SummaryDataDict
SHLIB = liblarcoreobj_SummaryData.so
SOURCES = $(filter-out $(DICT).cxx, $(wildcard *.cxx))
FMWK_HEADERS = LinkDef.h $(DICT).h classes.h
HEADERS = $(filter-out $(FMWK_HEADERS), $(wildcard *.h))
OBJECTS = $(SOURCES:.cxx=.o)

# include options for this package
INCFLAGS  = -I.                       #Include itself
INCFLAGS += -I$(LARLITE_USERDEVDIR)/larcoreobj/

INCLUDE_DIRS += $(LARLITE_USERDEVDIR)/larcoreobj/ 

# platform-specific options
OSNAME          = $(shell uname -s)
HOST            = $(shell uname -n)
OSNAMEMODE      = $(OSNAME)

include $(LARLITE_BASEDIR)/Makefile/Makefile.${OSNAME}

# set CINT flag
CINTFLAGS += -p
#LDFLAGS += -L$(LARLITE_LIBDIR) -llarcoreobj_SimpleTypesAndConstants

# call the common GNUmakefile
include $(LARLITE_BASEDIR)/Makefile/GNUmakefile.CORE



