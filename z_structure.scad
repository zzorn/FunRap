/*
 * Z axis structure.
 * 
 * Originally by Hans Häggström, 2010.
 * Licenced under Creative Commons Attribution-Share Alike 3.0.
 */

<units.scad>
<materials.scad>
<beam.scad>
<board.scad>
<rod.scad>
<stepper.scad>
<x_structure.scad>


// Uncomment to test:
// ZCarriageFrame(50*cm, 50*cm,0.5, Beam45x33, 8*mm);



module ZCarriageFrame(xSize, zSize, zCarriagePosition, xCarriagePosition, frameBeam, rodDiameter, zDriveRodPos1, zDriveRodPos2, rodDistanceFromEdge, stepperType) {
  part("Z Carriage Frame");

  bottomMovementMargin = 20*mm;
  topMovementMargin = 20*mm;
  slideHeight = 10*cm;
  
  threadedRodMargins = 10*mm;

  // Guide rods
  rs = beamHeigth(frameBeam) * 4/3;
  re = zSize - beamHeigth(frameBeam) * 1/3;
  r1s = [rodDistanceFromEdge,0,rs];
  r1e = [rodDistanceFromEdge,0,re];
  r2s = [xSize-rodDistanceFromEdge,0,rs];
  r2e = [xSize-rodDistanceFromEdge,0,re];
  rod(r1s, r1e, diameter=rodDiameter);
  rod(r2s, r2e, diameter=rodDiameter);

  // Threaded rods that lift the slide
  trs = threadedRodMargins;
  tre = zSize - beamHeigth(frameBeam) - threadedRodMargins;
  tr1s = zDriveRodPos1 + [0,0,trs]; // [beamWidth(frameBeam) - rodDistanceFromEdge,0,trs];
  tr1e = zDriveRodPos1 + [0,0,tre]; // [beamWidth(frameBeam) - rodDistanceFromEdge,0,tre];
  tr2s = zDriveRodPos2 + [0,0,trs]; // [xSize-beamWidth(frameBeam) + rodDistanceFromEdge,0,trs];
  tr2e = zDriveRodPos2 + [0,0,tre]; // [xSize-beamWidth(frameBeam) + rodDistanceFromEdge,0,tre];
  threadedRod(tr1s, tr1e, diameter=rodDiameter);
  threadedRod(tr2s, tr2e, diameter=rodDiameter);


  carriageMovement = [2*beamHeigth(frameBeam) + bottomMovementMargin, 
              zSize - beamHeigth(frameBeam) - topMovementMargin - slideHeight];

  travel = carriageMovement[1]-carriageMovement[0];

  echo(str("  --- Build area along Z axis: ", travel, " mm ---"));

  carriagePos = [0,0,zCarriagePosition * travel + carriageMovement[0]];

  translate(carriagePos) XCarriageFrame(xSize, xCarriagePosition, frameBeam, rodDistanceFromEdge, stepperType=stepperType);
}










