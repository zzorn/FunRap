/*
 * A design for a repstrap based on wooden beams and threaded rods.
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

// Uncomment to test:
// YCarriageFrame();



module YCarriageFrame(yCarriageSpace, yRodOffsets, yCarriagePosition, frameBeam, rodDiameter) {
  part("Y Carriage Frame");

  rodOffset = 10*mm;
  rodMarginFromEdges=10*mm;

  margin = 1*cm;

  buildAreaBorder = 3*cm;

  slideUnderstructureSize = 15*cm;

  r1s = [yRodOffsets[0], rodMarginFromEdges, 0];
  r1e = [yRodOffsets[0], yCarriageSpace[1]-rodMarginFromEdges, 0];
  r2s = [yCarriageSpace[0] - yRodOffsets[1], rodMarginFromEdges, 0];
  r2e = [yCarriageSpace[0] - yRodOffsets[1], yCarriageSpace[1]-rodMarginFromEdges, 0];

  rod(r1s, r1e, diameter=rodDiameter, align=[CENTER, TOP]);
  rod(r2s, r2e, diameter=rodDiameter, align=[CENTER, TOP]);


  carriageMovement = [beamWidth(frameBeam) + margin + slideUnderstructureSize/2, 
   yCarriageSpace[1] - beamWidth(frameBeam) - margin - slideUnderstructureSize/2];

  travel = carriageMovement[1]-carriageMovement[0];

  echo(str("  --- Build area along Y axis: ", travel, " mm ---"));

  carriageSize = [yCarriageSpace[0]- 2  *margin, travel + 2*buildAreaBorder];

  carriageZ = rodDiameter + rodOffset;
  carriageMidX = yCarriageSpace[0] / 2;
  carriageMidY = yCarriagePosition * travel + carriageMovement[0];
  carriagePos = [carriageMidX-carriageSize[0]/2, carriageMidY-carriageSize[1]/2, carriageZ];

  translate(carriagePos) YCarriageSlide(carriageSize);
}


module YCarriageSlide(surfaceSize) {
  part("Y Carriage Slide");
  board(size=surfaceSize);  
}








