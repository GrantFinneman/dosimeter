//
// ********************************************************************
// * License and Disclaimer                                           *
// *                                                                  *
// * The  Geant4 software  is  copyright of the Copyright Holders  of *
// * the Geant4 Collaboration.  It is provided  under  the terms  and *
// * conditions of the Geant4 Software License,  included in the file *
// * LICENSE and available at  http://cern.ch/geant4/license .  These *
// * include a list of copyright holders.                             *
// *                                                                  *
// * Neither the authors of this software system, nor their employing *
// * institutes,nor the agencies providing financial support for this *
// * work  make  any representation or  warranty, express or implied, *
// * regarding  this  software system or assume any liability for its *
// * use.  Please see the license in the file  LICENSE  and URL above *
// * for the full disclaimer and the limitation of liability.         *
// *                                                                  *
// * This  code  implementation is the result of  the  scientific and *
// * technical work of the GEANT4 collaboration.                      *
// * By using,  copying,  modifying or  distributing the software (or *
// * any work based  on the software)  you  agree  to acknowledge its *
// * use  in  resulting  scientific  publications,  and indicate your *
// * acceptance of all terms of the Geant4 Software license.          *
// ********************************************************************
//
/// \file runAndEvent/RE02/src/RE02DetectorConstruction.cc
/// \brief Implementation of the RE02DetectorConstruction class
//
//
// $Id: RE02DetectorConstruction.cc 101905 2016-12-07 11:34:39Z gunter $
//
 
#include "DetectorConstruction.hh"

#include "G4PSEnergyDeposit3D.hh"

#include "G4NistManager.hh"
#include "G4Material.hh"
#include "G4Box.hh"
#include "G4LogicalVolume.hh"
#include "G4PVPlacement.hh"
#include "G4SDManager.hh"

#include "G4VisAttributes.hh"
#include "G4Colour.hh"

#include "G4SystemOfUnits.hh"    
#include "G4ios.hh"

//=======================================================================
//  RE02DetectorConstruction
//
//  (Description)
//
//     Detector construction for example RE02.
//    
//   [Geometry] 
//     The world volume is defined as 200 cm x 200 cm x 200 cm box with Air.
//   Water detector is defined as  200 mm x 200 mm x 400 mm box with Water.
//   The water detector is divided into 100 segments in x,y plane using
//   replication,
//   and then divided into 200 segments perpendicular to z axis using nested 
//   parameterised volume.  
//    These values are defined at constructor,
//    e.g. the size of water detector (fDetectorSize), and number of segmentation
//   of water detector (fNx, fNy, fNz).
//
//   By default, lead plates are inserted into the position of even order 
//   segments.
//   NIST database is used for materials.
//
//
//   [Scorer]
//    Assignment of G4MultiFunctionalDetector and G4PrimitiveScorer 
//   is demonstrated in this example.
//       -------------------------------------------------
//       The collection names of defined Primitives are
//        0       DetectorSD/totalEDep 
//        1       DetectorSD/protonEDep
//        2       DetectorSD/protonNStep
//        3       DetectorSD/chargedPassCellFlux
//        4       DetectorSD/chargedCellFlux 
//        5       DetectorSD/chargedSurfFlux 
//        6       DetectorSD/gammaSurfCurr000
//        7       DetectorSD/gammaSurfCurr001
//        9       DetectorSD/gammaSurdCurr002
//       10       DetectorSD/gammaSurdCurr003
//      -------------------------------------------------
//      Please see README for detail description.
//
//=======================================================================

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......
DetectorConstruction::DetectorConstruction()
 : G4VUserDetectorConstruction() 
{

}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......
DetectorConstruction::~DetectorConstruction()
{;}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......
 G4VPhysicalVolume* DetectorConstruction::Construct()
{
  //=====================
  // Material Definitions
  //=====================
  //  
  //-------- NIST Materials ----------------------------------------------------
  //  Material Information imported from NIST database.
  //
  G4NistManager* NISTman = G4NistManager::Instance();
  G4Material* air  = NISTman->FindOrBuildMaterial("G4_AIR");
  G4Material* water = NISTman->FindOrBuildMaterial("G4_WATER");
  G4Material* al = NISTman->FindOrBuildMaterial("G4_Al");
  
  const G4float SiMass = 28.0855;
  const G4float HMass  = 1.008;
  const G4float OMass  = 16.00;
  const G4float CMass  = 12.011;
  //const G4double TotalMass;

  G4Element* elSi = new G4Element("Silicon", "Si", 14, SiMass*g/mole);
  G4Element* H = new G4Element("Hydrogen", "H", 1, HMass*g/mole);
  G4Element* O = new G4Element("Oxygen"  , "O", 8, OMass*g/mole);
  G4Element* elC = new G4Element("Carbon", "C", 6, CMass*g/mole );

  G4Material* PtP = new G4Material("P-Terphenyl", 1.24*g/cm3,2); // Component of Detector
  PtP->AddElement(elC,18);
  PtP->AddElement(H,14);

  G4Material* BisMSB = new G4Material("13280-61-0(1,4-bis(2-methylstyryl)benzene)",1.06*g/cm3,2); // Component of Detector
  BisMSB->AddElement(elC,24);
  BisMSB->AddElement(H,22);
	
  G4Material* Peroxide = new G4Material("Dicumyl Peroxide",1.56*g/cm3,3); // Component of Detector
  Peroxide->AddElement(elC,18);
  Peroxide->AddElement(H,22);
  Peroxide->AddElement(O,2);
	
  G4Material* hardsilCC = new G4Material("hardsilCC",0.95*g/cm3,4); // Component of Detector
  hardsilCC->AddElement(elSi,2);
  hardsilCC->AddElement(H,10);
  hardsilCC->AddElement(O,3);
  hardsilCC->AddElement(elC,12);

  G4Material* ScintX = new G4Material("ScintX",0.96*g/cm3,4); // Final Material
  ScintX->AddMaterial(PtP,0.9814*perCent);
  ScintX->AddMaterial(BisMSB,0.09814*perCent);
  ScintX->AddMaterial(Peroxide,0.7851*perCent);
  ScintX->AddMaterial(hardsilCC,98.14*perCent);

  //============================================================================
  //      Definitions of Solids, Logical Volumes, Physical Volumes 
  //============================================================================

  //-------------
  // World Volume 
  //-------------

  G4ThreeVector worldSize = G4ThreeVector(200*cm, 200*cm, 200*cm);
  
  G4Box * solidWorld
    = new G4Box("solidWorld", worldSize.x()/2., worldSize.y()/2., worldSize.z()/2.);
  G4LogicalVolume * logicWorld
    = new G4LogicalVolume(solidWorld, air, "logicWorld", 0, 0, 0);

  // 
  //  Must place the World Physical volume unrotated at (0,0,0).
  G4VPhysicalVolume * physiWorld
    = new G4PVPlacement(0,               // no rotation
                        G4ThreeVector(), // at (0,0,0)
                        logicWorld,      // its logical volume
                        "physWorld",     // its name
                        0,               // its mother  volume
                        false,           // no boolean operations
                        0);              // copy number
                                 
  //---------------
  // Water Detector
  //---------------

  //--  Default size of water detector is defined at constructor.
  G4ThreeVector detectorSize = G4ThreeVector(80*mm, 80*mm, 48*mm);
  fNx = 1; // Number of Bars across X
  fNy = 8; // Number of Bars across Y
  fNz = 8; // Number of Bars across Z

  G4Box * solidDetector
    = new G4Box("detector",
                detectorSize.x()/2., detectorSize.y()/2., detectorSize.z()/2.);
  G4LogicalVolume * logicDetector
    = new G4LogicalVolume(solidDetector, air, "Detector", 0, 0, 0);

  G4RotationMatrix* rot = new G4RotationMatrix();
  rot->rotateX(0*deg);
  rot->rotateY(0*deg);
  rot->rotateZ(0*deg);
  G4ThreeVector positionDetector = G4ThreeVector(0, 0, 0);
  //G4VPhysicalVolume * physiDetector =
  new G4PVPlacement(rot,             // no rotation
                    positionDetector, // at (x,y,z)
                    logicDetector,    // its logical volume
                    "Detector",       // its name
                    logicWorld,      // its mother  volume
                    false,           // no boolean operations
                    0);              // copy number 

  // Layer

  G4Box* solidLayer = new G4Box("solidLayer", detectorSize.x()/2, detectorSize.y()/2, detectorSize.z()/(2*fNz));
  G4LogicalVolume* logicLayer = new G4LogicalVolume(solidLayer, air, "logicLayer");

  // Bar Wrapping
  
  G4Box* solidWrap = new G4Box("solidWrap", detectorSize.x()/2, detectorSize.y()/(2*fNy), detectorSize.z()/(2*fNz));
  G4LogicalVolume* logicWrap = new G4LogicalVolume(solidWrap, al, "logicWrap");
  
  // Bar
  G4double wrapThickness = 0.006*mm;
  
  G4Box* solidBar = new G4Box("solidBar", detectorSize.x()/2-wrapThickness, detectorSize.y()/(2*fNy)-wrapThickness, detectorSize.z()/(2*fNz)-wrapThickness);
  logicBar = new G4LogicalVolume(solidBar, ScintX, "logicBar");
  G4RotationMatrix* noRot = new G4RotationMatrix();
  noRot->rotateX(0*deg);
  noRot->rotateY(0*deg);
  noRot->rotateZ(0*deg);

  // Placement in Detector
  
  new G4PVPlacement(noRot, G4ThreeVector(0,0,0), logicBar, "barPhys", logicWrap, false, 0); // Bar Placement in Wrapping

  for (int numBar = 0; numBar < fNy; numBar++) {
    new G4PVPlacement(noRot, G4ThreeVector(0, detectorSize.y()*((-0.5)+(1/(double)fNy)*(double)(numBar+0.5)), 0), logicWrap, "wrapPhys", logicLayer, false, numBar); // Place wrapped bars in each layer
  }
  
  for (int numLayer = 0; numLayer < fNz; numLayer++) {
    new G4PVPlacement(noRot, G4ThreeVector(0, 0, detectorSize.z()*((-0.5)+(1/(double)fNz)*(double)(numLayer+0.5))), logicLayer, "layerPhys", logicDetector, false, numLayer); // Place layers in detector
  }
  
  //=============================== 
  //   Visualization attributes 
  //===============================

  G4VisAttributes* boxVisAtt = new G4VisAttributes(G4Colour(1.0,1.0,1.0));
  logicWorld->SetVisAttributes(boxVisAtt);  
  //logicWorld->SetVisAttributes(G4VisAttributes::GetInvisible());  

  // Mother volume of WaterDetector
  G4VisAttributes* detectorVisAtt = new G4VisAttributes(G4Colour(1.0,1.0,0.0));
  logicDetector->SetVisAttributes(detectorVisAtt);
  
  G4VisAttributes* voxelVisAtt = new G4VisAttributes(G4Colour(0.0,1.0,1.0));
  logicWrap->SetVisAttributes(voxelVisAtt);
  //fLVDetectorSens->SetVisAttributes(G4VisAttributes::GetInvisible());

  
  return physiWorld;
}

void DetectorConstruction::ConstructSDandField() {

  //================================================
  // Sensitive detectors : MultiFunctionalDetector
  //================================================
  //
  //  Sensitive Detector Manager.
  G4SDManager* pSDman = G4SDManager::GetSDMpointer();
  //
  // Sensitive Detector Name
  G4String detectorSDname = "DetectorSD";
  
  //------------------------
  // MultiFunctionalDetector
  //------------------------
  //
  // Define MultiFunctionalDetector with name.
  G4MultiFunctionalDetector* mFDet
  = new G4MultiFunctionalDetector(detectorSDname);
  pSDman->AddNewDetector( mFDet );                // Register SD to SDManager.
  logicBar->SetSensitiveDetector(mFDet);    // Assign SD to the logical volume.
  
  //------------------------
  // PS : Primitive Scorers
  //------------------------
  // Primitive Scorers are used with SDFilters according to your purpose.
  //
  //
  //-- Primitive Scorer for Energy Deposit.
  //      Total, by protons, by electrons, by neutrons.
  G4String psName;
  G4PSEnergyDeposit3D * scorer0 = new G4PSEnergyDeposit3D(psName="totalEDep",
                                                          fNx,fNy,fNz);
  //
  //------------------------------------------------------------
  //  Register primitive scorers to MultiFunctionalDetector
  //------------------------------------------------------------
  mFDet->RegisterPrimitive(scorer0);

}

