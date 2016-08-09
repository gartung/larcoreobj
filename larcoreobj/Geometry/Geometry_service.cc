/**
 * @file   Geometry_service.cc
 * @brief  art framework interface to geometry description - implementation file
 * @author brebel@fnal.gov
 * @see    Geometry.h
 */

// class header
#include "larcoreobj/Geometry/Geometry.h"

// lar includes
#include "larcoreobj/SimpleTypesAndConstants/geo_types.h"
#include "larcoreobj/SummaryData/RunData.h"
#include "larcoreobj/Geometry/ExptGeoHelperInterface.h"

// Framework includes
#include "cetlib/exception.h"
#include "cetlib/search_path.h"
#include "messagefacility/MessageLogger/MessageLogger.h"

// C/C++ standard libraries
#include <vector>
#include <string>


namespace geo {


  //......................................................................
  // Constructor.
  Geometry::Geometry(fhicl::ParameterSet const& pset, art::ActivityRegistry &reg)
    : GeometryCore(pset)
    , fRelPath          (pset.get< std::string       >("RelativePath",     ""   ))
    , fDisableWiresInG4 (pset.get< bool              >("DisableWiresInG4", false))
    , fForceUseFCLOnly  (pset.get< bool              >("ForceUseFCLOnly" , false))
    , fSortingParameters(pset.get<fhicl::ParameterSet>("SortingParameters", fhicl::ParameterSet() ))
  {
    // add a final directory separator ("/") to fRelPath if not already there
    if (!fRelPath.empty() && (fRelPath.back() != '/')) fRelPath += '/';
    
    // register a callback to be executed when a new run starts
    reg.sPreBeginRun.watch(this, &Geometry::preBeginRun);
    
    //......................................................................
    // 5.15.12 BJR: use the gdml file for both the fGDMLFile and fROOTFile
    // variables as ROOT v5.30.06 is once again able to read in gdml files
    // during batch operation, in this case think of fROOTFile meaning the
    // file used to make the ROOT TGeoManager.  I don't want to remove
    // the separate variables in case ROOT breaks again
    std::string GDMLFileName = pset.get<std::string>("GDML");
    std::string ROOTFileName = pset.get<std::string>("GDML");
    
    // load the geometry
    LoadNewGeometry(GDMLFileName, ROOTFileName);
    
  } // Geometry::Geometry()


  void Geometry::preBeginRun(art::Run const& run)
  {
    // FIXME this seems utterly wrong: constructor loads geometry based on an
    // explicit parameter, whereas here we load it by detector name
    
    // if we are requested to stick to the configured geometry, do nothing
    if (fForceUseFCLOnly) return;
    
    // check here to see if we need to load a new geometry.
    // get the detector id from the run object
    std::vector< art::Handle<sumdata::RunData> > rdcol;
    run.getManyByType(rdcol);
    if (rdcol.empty()) {
      mf::LogWarning("LoadNewGeometry") << "cannot find sumdata::RunData object to grab detector name\n" 
                                        << "this is expected if generating MC files\n"
                                        << "using default geometry from configuration file\n";
      return;
    }
    
    // if the detector name is still the same, everything is fine
    std::string newDetectorName = rdcol.front()->DetName();
    if (DetectorName() == newDetectorName) return;
    
    // check to see if the detector name in the RunData
    // object has not been set.
    std::string const nodetname("nodetectorname");
    if (newDetectorName == nodetname) {
      LOG_WARNING("Geometry") << "Detector name not set: " << newDetectorName;
    } // if no detector name stored
    else {
      // the detector name is specified in the RunData object
      SetDetectorName(newDetectorName);
    }
    
    LoadNewGeometry(DetectorName() + ".gdml", DetectorName() + ".gdml", true);
  } // Geometry::preBeginRun()
  
  
  //......................................................................
  void Geometry::InitializeChannelMap()
  {
    // the channel map is responsible of calling the channel map configuration
    // of the geometry
    art::ServiceHandle<geo::ExptGeoHelperInterface>()
      ->ConfigureChannelMapAlg(fSortingParameters, this);
    
    if ( ! ChannelMap() ) {
      throw cet::exception("ChannelMapLoadFail")
        << " failed to load new channel map";
    }
    
  } // Geometry::InitializeChannelMap()

  //......................................................................
  void Geometry::LoadNewGeometry(
    std::string gdmlfile, std::string /* rootfile */,
    bool bForceReload /* = false */
  ) {
    // start with the relative path
    std::string GDMLFileName(fRelPath), ROOTFileName(fRelPath);
    
    // add the base file names
    ROOTFileName.append(gdmlfile); // not rootfile (why?)
    GDMLFileName.append(gdmlfile);
    
    // special for GDML if geometry with no wires is used for Geant4 simulation
    if(fDisableWiresInG4)
      GDMLFileName.insert(GDMLFileName.find(".gdml"), "_nowires");
    
    // Search all reasonable locations for the GDML file that contains
    // the detector geometry.
    // cet::search_path constructor decides if initialized value is a path
    // or an environment variable
    cet::search_path sp("FW_SEARCH_PATH");
    
    std::string GDMLfile;
    if( !sp.find_file(GDMLFileName, GDMLfile) ) {
      throw cet::exception("Geometry")
        << "cannot find the gdml geometry file:" 
        << "\n" << GDMLFileName
        << "\nbail ungracefully.\n";
    }
    
    std::string ROOTfile;
    if( !sp.find_file(ROOTFileName, ROOTfile) ) {
      throw cet::exception("Geometry")
        << "cannot find the root geometry file:\n"
        << "\n" << ROOTFileName
        << "\nbail ungracefully.\n";
    }
    
    // initialize the geometry with the files we have found
    LoadGeometryFile(GDMLfile, ROOTfile, bForceReload);
    
    // now update the channel map
    InitializeChannelMap();
    
  } // Geometry::LoadNewGeometry()
  
  DEFINE_ART_SERVICE(Geometry)
} // namespace geo
