//
// cint script to generate libraries
// Declaire namespace & classes you defined
// #pragma statement: order matters! Google it ;)
//

#ifdef __CINT__
#pragma link off all globals;
#pragma link off all classes;
#pragma link off all functions;

#pragma link C++ namespace geo+;
#pragma link C++ class geo::Geometry+;
#pragma link C++ class geo::AuxDetChannelMapAlg+;
#pragma link C++ class geo::AuxDetExptGeoHelperInterface+;
#pragma link C++ class geo::AuxDetGeo+;
#pragma link C++ class geo::AuxDetGeometryCore+;
#pragma link C++ class geo::AuxDetGeometry+;
#pragma link C++ class geo::AuxDetSensitiveGeo+;
#pragma link C++ class geo::BoxBoundedGeo+;
#pragma link C++ class geo::ChannelMapAlg+;
#pragma link C++ class geo::ChannelMapStandardAlg+;
#pragma link C++ class geo::CryostatGeo+;
#pragma link C++ class geo::ExptGeoHelperInterface+;
#pragma link C++ class geo::GeometryCore+;
#pragma link C++ class geo::OpDetGeo+;
#pragma link C++ class geo::PlaneGeo+;
#pragma link C++ class geo::StandardGeometryHelper+;
#pragma link C++ class geo::TPCGeo+;
//ADD_NEW_CLASS ... do not change this line

#endif
