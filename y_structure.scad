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
<bearing.scad>
<rod.scad>
<stepper.scad>

// Uncomment to test:
 YCarriageFrame();



module YCarriageFrame(yCarriageSpace=[50*cm,50*cm], yRodOffsets=[90*mm,90*mm], yCarriagePosition=0, frameBeam=Beam45x33, rodDiameter=8*mm, bearingModel=SkateBearing) {
  part("Y Carriage Frame");

  rodOffset = 10*mm;
  rodMarginFromEdges=10*mm;

  margin = 1*cm;

  buildAreaBorder = 3*cm;

  slideUnderstructureSize = 15*cm;

  rod1X = yRodOffsets[0];
  rod2X = yCarriageSpace[0] - yRodOffsets[1];

  r1s = [rod1X, rodMarginFromEdges, 0];
  r1e = [rod1X, yCarriageSpace[1]-rodMarginFromEdges, 0];
  r2s = [rod2X, rodMarginFromEdges, 0];
  r2e = [rod2X, yCarriageSpace[1]-rodMarginFromEdges, 0];

  rod(r1s, r1e, diameter=rodDiameter, align=[CENTER, TOP]);
  rod(r2s, r2e, diameter=rodDiameter, align=[CENTER, TOP]);


  carriageMovement = [beamWidth(frameBeam) + margin + slideUnderstructureSize/2, 
   yCarriageSpace[1] - beamWidth(frameBeam) - margin - slideUnderstructureSize/2];

  travel = carriageMovement[1]-carriageMovement[0];

  echo(str("  --- Build area along Y axis: ", travel, " mm ---"));

  carriageSize = [yCarriageSpace[0]- 2  *margin, travel + 2*buildAreaBorder];

  carriageZ = rodDiameter + bearingOuterDiameter(bearingModel) + 4*mm;
  carriageMidX = yCarriageSpace[0] / 2;
  carriageMidY = yCarriagePosition * travel + carriageMovement[0];
  carriageXOffs = carriageMidX-carriageSize[0]/2;
  carriagePos = [carriageXOffs, carriageMidY-carriageSize[1]/2, carriageZ];

  translate(carriagePos) YCarriageSlide(carriageSize, slideUnderstructureSize, frameBeam,  rod1X-carriageXOffs, rod2X-carriageXOffs, rodMarginFromEdges, rodDiameter,bearingModel);
}


module YCarriageSlide(surfaceSize, slideUnderstructureSize, frameBeam,  rod1X, rod2X, rodMarginFromEdges, rodDiameter,bearingModel) {
  part("Y Carriage Slide");

  board(size=surfaceSize);  

  bw= beamWidth(frameBeam);
  bh= beamHeigth(frameBeam);
  midY = surfaceSize[1] /2;

  bearD = bearingOuterDiameter(bearingModel);
  
  bearingX = rod1X - bearingWidth(bearingModel)/2;
  bearingZ = -bearD/2 - 4*mm;
  startX = rod1X + bearingWidth(bearingModel)/2 + 5*mm;
  endX = rod2X + 2*rodMarginFromEdges + rodDiameter / 2;

  y1 = midY - slideUnderstructureSize/2;
  y2 = midY + slideUnderstructureSize/2;

  b1s = [startX, y1, 0];
  b1e = [endX, y1, 0];
  b2s = [startX, y2, 0];
  b2e = [endX, y2, 0];

  beam(b1s, b1e, model=frameBeam, align=[LEFT, TOP], rotation=270);
  beam(b2e, b2s, model=frameBeam, align=[LEFT, TOP], rotation=270);
  bearing(model=bearingModel,pos=[bearingX, y1+bh/2, bearingZ], angle=[0,90,0]);
  bearing(model=bearingModel,pos=[bearingX, y2-bh/2, bearingZ], angle=[0,90,0]);
}








