cet_make_library( 
  LIBRARY_NAME
    larcoreobj_SummaryData
  SOURCE
    POTSummary.cxx
    RunData.cxx
)

add_subdirectory(SampledDicts)

install_headers()
install_source()
