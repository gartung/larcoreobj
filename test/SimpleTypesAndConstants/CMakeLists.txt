# ======================================================================
#
# Testing
#
# ======================================================================

cet_test( geo_types_test USE_BOOST_UNIT 
  LIBRARIES
    cetlib::cetlib
  )
cet_test( readout_types_test USE_BOOST_UNIT 
  LIBRARIES
    cetlib::cetlib
  )
cet_test( geo_types_fhicl_test USE_BOOST_UNIT
  LIBRARIES
    fhiclcpp::fhiclcpp
    cetlib_except::cetlib_except
    cetlib::cetlib
  )
cet_test( readout_types_fhicl_test USE_BOOST_UNIT
  LIBRARIES
    fhiclcpp::fhiclcpp
    cetlib_except::cetlib_except
    cetlib::cetlib
  )
cet_test( testPhysicalConstants )
