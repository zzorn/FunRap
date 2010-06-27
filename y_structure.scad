/*
 * Y axis structure.
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
// YCarriageFrame();



module YCarriageFrame(yCarriageSpace=[50*cm,50*cm], yRodOffsets=[90*mm,90*mm], yCarriagePosition=0, frameBeam=Beam45x33, rodDiameter=8*mm, bearingModel=SkateBearing, motorBeam=Beam70x10, motorType=Nema23) {
  part("Y Carriage Frame");

  rodOffset = 10*mm;
  rodMarginFromEdges=12.5*mm;

  margin = 4*cm;
  sideMargin = 0.5*cm;

  buildAreaBorder = 6*cm;

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

  carriageSize = [yCarriageSpace[0]- 2  *sideMargin, travel + 2*buildAreaBorder];

  bearingCleaing = 2*mm;
  carriageZ = rodDiameter + bearingOuterDiameter(bearingModel) + bearingCleaing;
  carriageMidX = yCarriageSpace[0] / 2;
  carriageMidY = yCarriagePosition * travel + carriageMovement[0];
  carriageXOffs = carriageMidX-carriageSize[0]/2;
  carriagePos = [carriageXOffs, carriageMidY-carriageSize[1]/2, carriageZ];

  translate(carriagePos) YCarriageSlide(carriageSize, slideUnderstructureSize, frameBeam,  rod1X-carriageXOffs, rod2X-carriageXOffs, rodMarginFromEdges, rodDiameter,bearingModel, bearingCleaing);
  
  // Motor
  idlerEdgeDistance = beamWidth(frameBeam) + 20*mm;
  motorPos = [-beamWidth(motorBeam)/2, idlerEdgeDistance+2*cm, beamHeigth(motorBeam)];
  motor(model=motorType, pos=motorPos);

  pulleyPos = motorPos + [0, 0, -beamHeigth(motorBeam)];
  pulley(pos=pulleyPos, angle=[180,0,0], model=Pulley16x9);
  
  // Idlers
  midIdlerX = yCarriageSpace[0]*0.33;
  idlerZ = -10*mm;
  sideIdlerX = motorPos[0] + 2*cm;
  beltIdler1 = [midIdlerX, yCarriageSpace[1] - idlerEdgeDistance, idlerZ];
  beltIdler2 = [midIdlerX, idlerEdgeDistance, idlerZ];
  beltIdler3 = [sideIdlerX, motorPos[1] + 4*cm, idlerZ];
  beltIdler4 = [midIdlerX - 4*cm, yCarriageSpace[1] - idlerEdgeDistance, idlerZ];
  bearing(pos=beltIdler1, model=bearingModel);
  bearing(pos=beltIdler2, model=bearingModel);
  bearing(pos=beltIdler3, model=bearingModel);
  bearing(pos=beltIdler4, model=bearingModel);
  
  // Belt
  attachYOffs = carriageSize[1]/2 - slideUnderstructureSize/2 - 2*cm;
  beltSlideAttachment1 = [midIdlerX, carriageMidY-attachYOffs, idlerZ];
  beltSlideAttachment2 = [midIdlerX, carriageMidY+attachYOffs, idlerZ];
  translate([0,0,4*mm]) belt(7, [beltSlideAttachment2, beltIdler1, beltIdler4, beltIdler3, pulleyPos-[0,0,15*mm], beltIdler2, beltSlideAttachment1], model=TimingBelt_XL_025, closed=false);
}


module YCarriageSlide(surfaceSize, slideUnderstructureSize, frameBeam,  rod1X, rod2X, rodMarginFromEdges, rodDiameter,bearingModel, bearingCleaing) {
  part("Y Carriage Slide");

  board(size=surfaceSize);  

  bw= beamWidth(frameBeam);
  bh= beamHeigth(frameBeam);
  midY = surfaceSize[1] /2;

  bearD = bearingOuterDiameter(bearingModel);
  
  bearingX = rod2X - bearingWidth(bearingModel)/2;
  bearingZ = -bearD/2 - bearingCleaing;
  startX = rod1X - (2*rodMarginFromEdges + rodDiameter / 2);
  endX = rod2X - (bearingWidth(bearingModel)/2 + 5*mm);

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








