#
# This is an example GNUmakefile for my packages
#

# specific names for this package
DICT  = larcoreobj_GeometryDict
SHLIB = liblarcoreobj_Geometry.so
SOURCES = $(filter-out $(DICT).cxx, $(wildcard *.cxx))
FMWK_HEADERS = LinkDef.h $(DICT).h classes.h
HEADERS = $(filter-out $(FMWK_HEADERS), $(wildcard *.h))
OBJECTS = $(SOURCES:.cxx=.o)

# include options for this package
INCFLAGS  = -I.                       #Include itself
INCFLAGS += -I${LARLITE_USERDEVDIR}/larcoreobj
INCFLAGS += -I${ART_INC}
INCFLAGS += -I${CETLIB_INC}
INCFLAGS += -I${FHICLCPP_INC}
INCFLAGS += -I${MESSAGEFACILITY_INC}
INCFLAGS += -I${CLHEP_INC}
INCFLAGS += -I${CANVAS_INC}

# platform-specific options
OSNAME          = $(shell uname -s)
HOST            = $(shell uname -n)
OSNAMEMODE      = $(OSNAME)

include $(LARLITE_BASEDIR)/Makefile/Makefile.${OSNAME}

# set CINT flag
CINTFLAGS += -p

# call the common GNUmakefile
include $(LARLITE_BASEDIR)/Makefile/GNUmakefile.CORE



