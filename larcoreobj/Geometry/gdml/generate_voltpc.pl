#!/usr/bin/perl

use Math::Trig;
use XML::LibXML;
use Getopt::Long;


#Specific H,W,L of volTPC
$CryostatWidth=200;
$CryostatHeight=200;
$CryostatLength=1000;

#detector variables
$SteelThickness=0.5*2.54;
$ArgonWidth=$CryostatWidth-2*$SteelThickness;
$ArgonHeight=$CryostatHeight-2*$SteelThickness;
$ArgonLength=$CryostatLength-2*$SteelThickness;
$RockThickness=200;
$ConcretePadding=50;
$GlassFoamPadding=100;
$TotalPadding=$ConcretePadding+$GlassFoamPadding+$SteelThickness;
$CavernWidth=$ArgonWidth+2*$TotalPadding;
$CavernHeight=$ArgonHeight+$TotalPadding;
$CavernLength=$ArgonLength+2*$TotalPadding;
$TPCWidth=$CryostatWidth;
$TPCHeight=$CryostatHeight;
$TPCLength=$CryostatLength;
$TPCWireThickness=0.015;


gen_header();
gen_materials();
gen_voltpc();
exit;






sub gen_voltpc()
{
  # Set up the output file.
  $volTPC = "voltpc.gdml";
  $volTPC = ">>" . $volTPC;
  open(volTPC) or die("Could not open file $volTPC for writing");

  print volTPC <<EOF;
  <solids>
    <box name="World" lunit="cm" 
      x="5*$CryostatWidth" 
      y="5*$CryostatHeight" 
      z="5*$CryostatLength"/>
    <box name="DetEnclosure" lunit="cm" 
      x="$CryostatWidth+10" 
      y="$CryostatHeight+10" 
      z="$CryostatLength+10"/>
    <box name="Cryostat" lunit="cm" 
      x="$CryostatWidth" 
      y="$CryostatHeight" 
      z="$CryostatLength"/>
    <box name="TPC" lunit="cm" 
      x="$TPCWidth" 
      y="$TPCHeight" 
      z="$TPCLength"/>
    <box name="TPCPlane" lunit="cm" 
      x="0.1" 
      y="0.9*$TPCHeight" 
      z="0.9*$TPCLength"/>
    <tube name="TPCWire"
      rmax="0.5*$TPCWireThickness"
      z="0.89*$TPCHeight"               
      deltaphi="2*3.14159"
      aunit="rad"
      lunit="cm"/>

  </solids>
  <structure>
    <volume name="volTPCWire">
      <materialref ref="STEEL_STAINLESS_Fe7Cr2Ni" />
      <solidref ref="TPCWire" />
    </volume>
    <volume name="volTPCPlane">
      <materialref ref="LAr"/>
      <solidref ref="TPCPlane"/>
EOF

for ( $i=-0.3*$TPCLength ; $i < 0.3*$TPCLength ; $i+=100 ) {
    $wire_zpos=$i;
      print volTPC <<EOF;
      <physvol>
        <volumeref ref="volTPCWire"/>
        <position name="posTPCWire$i" unit="cm" x="0" y="0" z="$wire_zpos"/>
        <rotation name="rTPCWire$i" unit="deg" x="60" y="0" z="0"/>
      </physvol>
EOF
}
    print volTPC <<EOF;
    </volume>
    <volume name="volTPC">
      <materialref ref="LAr" />
      <solidref ref="TPC" />
      <physvol>
        <volumeref ref="volTPCPlane"/>
        <position name="posTPCPlane1" unit="cm" x="-0.45*$TPCWidth" y="0" z="0"/>
      </physvol>
      <physvol>
        <volumeref ref="volTPCPlane"/>
        <position name="posTPCPlane2" unit="cm" x="-0.475*$TPCWidth" y="0" z="0"/>
        <rotation name="rTPCPlane2" unit="deg" x="0" y="180" z="0"/>
      </physvol>
    </volume>
    <volume name="volCryostat">
      <materialref ref="LAr" />
      <solidref ref="Cryostat" />
        <physvol>
          <volumeref ref="volTPC"/>
          <position name="posTPC" unit="cm" x="0" y="0" z="0"/>
        </physvol>
    </volume>
    <volume name="volDetEnclosure">
      <materialref ref="Air"/>
      <solidref ref="DetEnclosure"/>
      <physvol>
        <volumeref ref="volCryostat"/>
        <position name="posCryostat" unit="cm" x="0" y="0" z="0"/>
      </physvol>
    </volume>
    <volume name="volWorld" >
      <materialref ref="Air"/>
      <solidref ref="World"/>
      <physvol>
        <volumeref ref="volDetEnclosure"/>
        <position name="posDetEnclosure" unit="cm" x="0.5*$TPCWidth" y="0" z="0.5*$TPCLength"/>
      </physvol>
    </volume>
  </structure>

  <setup name="Default" version="1.0">
    <world ref="volWorld" />
  </setup>
</gdml>
EOF
   close(volTPC);
}


#generates necessary gd/xml header
sub gen_header() 
{

  $volTPC = "voltpc.gdml";
  $volTPC = ">" . $volTPC;
  open(volTPC) or die("Could not open file $volTPC for writing");
  print volTPC <<EOF;
<?xml version="1.0" encoding="UTF-8" ?>
<gdml xmlns:gdml="http://cern.ch/2001/Schemas/GDML"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="GDMLSchema/gdml.xsd">
EOF
}


sub gen_materials() 
{


  $volTPC = "voltpc.gdml";
  $volTPC = ">>" . $volTPC;
  open(volTPC) or die("Could not open file $volTPC for writing");
  print volTPC <<EOF;
  <materials>
    <element name="videRef" formula="VACUUM" Z="1">  <atom value="1"/> </element>
    <element name="hydrogen" formula="H" Z="1">  <atom value="1.0079"/> </element>
    <element name="nitrogen" formula="N" Z="7">  <atom value="14.0067"/> </element>
    <element name="oxygen" formula="O" Z="8">  <atom value="15.999"/> </element>
    <element name="aluminum" formula="Al" Z="13"> <atom value="26.9815"/>  </element>
    <element name="silicon" formula="Si" Z="14"> <atom value="28.0855"/>  </element>
    <element name="carbon" formula="C" Z="6">  <atom value="12.0107"/>  </element>
    <element name="potassium" formula="K" Z="19"> <atom value="39.0983"/>  </element>
    <element name="chromium" formula="Cr" Z="24"> <atom value="51.9961"/>  </element>
    <element name="iron" formula="Fe" Z="26"> <atom value="55.8450"/>  </element>
    <element name="nickel" formula="Ni" Z="28"> <atom value="58.6934"/>  </element>
    <element name="calcium" formula="Ca" Z="20"> <atom value="40.078"/>   </element>
    <element name="sodium" formula="Na" Z="11"> <atom value="22.99"/>    </element>
    <element name="argon" formula="Ar" Z="18"> <atom value="39.9480"/>  </element>

    <material name="Vacuum" formula="Vacuum">
      <D value="1.e-25" unit="g/cm3"/>
      <fraction n="1.0" ref="videRef"/>
    </material>
  
    <material name="STEEL_STAINLESS_Fe7Cr2Ni" formula="STEEL_STAINLESS_Fe7Cr2Ni">
      <D value="7.9300" unit="g/cm3"/>
      <fraction n="0.0010" ref="carbon"/>
      <fraction n="0.1800" ref="chromium"/>
      <fraction n="0.7298" ref="iron"/>
      <fraction n="0.0900" ref="nickel"/>
    </material>
  
    <material name="LAr" formula="LAr">
      <D value="1.40" unit="g/cm3"/>
      <fraction n="1.0000" ref="argon"/>
    </material>
  
    <material formula=" " name="Air">
      <D value="0.001205" unit="g/cm3"/>
      <fraction n="0.78084" ref="nitrogen"/>
      <fraction n="0.209476" ref="oxygen"/>
      <fraction n="0.00934" ref="argon"/>
    </material>
  
    <material formula=" " name="Granite">
      <D value="2.7" unit="g/cm3"/>
      <fraction n="0.438" ref="oxygen"/>
      <fraction n="0.257" ref="silicon"/>
      <fraction n="0.222" ref="sodium"/>
      <fraction n="0.049" ref="aluminum"/>
      <fraction n="0.019" ref="iron"/>
      <fraction n="0.015" ref="potassium"/>
    </material>
 
    <material formula=" " name="Dirt">
      <D value="1.7" unit="g/cm3"/>
      <fraction n="0.438" ref="oxygen"/>
      <fraction n="0.257" ref="silicon"/>
      <fraction n="0.222" ref="sodium"/>
      <fraction n="0.049" ref="aluminum"/>
      <fraction n="0.019" ref="iron"/>
      <fraction n="0.015" ref="potassium"/>
    </material>
  
    <material formula=" " name="Concrete">
      <D value="2.3" unit="g/cm3"/>
      <fraction n="0.530" ref="oxygen"/>
      <fraction n="0.335" ref="silicon"/>
      <fraction n="0.060" ref="calcium"/>
      <fraction n="0.015" ref="sodium"/>
      <fraction n="0.020" ref="iron"/>
      <fraction n="0.040" ref="aluminum"/>
    </material>
  </materials>
EOF
}

