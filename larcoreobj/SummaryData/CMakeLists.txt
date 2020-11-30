cet_make_library( 
  SOURCE
    POTSummary.cxx
    RunData.cxx
)

build_dictionary(DICTIONARY_LIBRARIES larcoreobj_SummaryData)

add_subdirectory(SampledDicts)

install_headers()
install_source()
