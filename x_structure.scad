/*
 * X axis structure.
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
<bearing.scad>

// Uncomment to test:
// XCarriageFrame(50*cm, Beam45x33);


module XCarriageFrame(xSize, frameBeam, rodDistanceFromEdge, motorBeam=Beam70x10, stepperType=Nema23, rodDiameter = 8*mm, bearingModel=SkateBearing) {
  part("X Carriage Frame");


  
  xRodSeparation = beamWidth(motorBeam) + rodDiameter;

  margin = 1*cm;

  bearRadius = bearingOuterDiameter(bearingModel) / 2;
  baseZ = bearRadius*2 + margin;

  w = beamWidth(frameBeam);
  h = beamHeigth(frameBeam);

  // Rod support beams
  rodSep = xRodSeparation/2;
  x2 = xSize;// - w + rodDiameter + 1.5*rodMarginFromEdges;
  l = rodDistanceFromEdge + rodSep + rodDiameter;
  l2 = rodDiameter / 2 + bearRadius + rodDistanceFromEdge + 1*cm;
  //x2_ = x2 - beamHeigth(motorBeam);
  beam([0,-l,baseZ], [0,l,baseZ], frameBeam, align=[RIGHT, TOP]);
  beam([0,-l,baseZ], [0,l,baseZ], frameBeam, align=[RIGHT, BOTTOM]);
  beam([x2 ,l,baseZ], [x2 ,-l,baseZ], frameBeam, align=[RIGHT, TOP]);

  // Bearing slider  
  bearingSliderLength = bearRadius*4 + margin*2+h;
  beam([x2,0,0], [x2,0,bearingSliderLength], motorBeam, align=[CENTER, BOTTOM]);

  bOffs = bearRadius + rodDiameter/2;
  bw = bearingWidth(bearingModel);
  bx = xSize - rodDistanceFromEdge - bw/2;
  bz1 = rodDistanceFromEdge; 
  bz2 = bearingSliderLength - rodDistanceFromEdge; 
  bearing([bx, -bOffs, bz1], angle=[0,90,0], model=bearingModel);
  bearing([bx,  bOffs, bz1], angle=[0,90,0], model=bearingModel);
  bearing([bx, -bOffs, bz2], angle=[0,90,0], model=bearingModel);
  bearing([bx,  bOffs, bz2], angle=[0,90,0], model=bearingModel);
  
  // Rods
  rodX1 = w/3;
  rodX2 = x2 + beamHeigth(motorBeam);
  rodZ = h + rodDiameter/2 + baseZ;
  rod([rodX1, -rodSep, rodZ], [rodX2, -rodSep, rodZ], diameter=rodDiameter);
  rod([rodX1,  rodSep, rodZ], [rodX2,  rodSep, rodZ], diameter=rodDiameter);

  // Motor
  idlerReserve = 2*bearRadius;
  mbh = beamHeigth(frameBeam) + baseZ;
  mbx1 = -motorWidth(stepperType) - margin - idlerReserve;
  mbx2 = w;
  motorX = mbx1 + margin + idlerReserve + motorWidth(stepperType) / 2;
  beam([mbx1,0,mbh], [mbx2,0,mbh], motorBeam);
  motor(stepperType, pos=[motorX, 0, mbh], orientation=[180,0,0], dualAxis=true);

  // Idlers for cable
  cableZ = mbh+beamHeigth(motorBeam) + 10 * mm;
  motorIdlerX1 = mbx1 + bearRadius + margin/2;
  motorIdlerX2 = x2 - w + margin;
  motorIdlerY = xRodSeparation / 2 - bearRadius - margin/2;
  bearing(pos=[motorIdlerX1,  motorIdlerY, cableZ], model=bearingModel);
  bearing(pos=[motorIdlerX1, -motorIdlerY, cableZ], model=bearingModel);
  bearing(pos=[motorIdlerX2,  motorIdlerY, cableZ], model=bearingModel);
  bearing(pos=[motorIdlerX2, -motorIdlerY, cableZ], model=bearingModel);

  // Moving x carriage
  carriageX = 10*cm; // TODO
  translate([carriageX, 0, mbh+rodDiameter/2]) XCarriageSlide(motorBeam, frameBeam, xRodSeparation, rodDiameter, rodDistanceFromEdge, bearingModel);

}

module XCarriageSlide(flatBeam, squareBeam, rodDistance, rodDiam, rodMargin, bearingModel=SkateBearing, carriageLength=12*cm,  ) {
  part("X Carriage Slide");
  
  bearingDiam =  bearingOuterDiameter(bearingModel);
  bearingWidth =  bearingWidth(bearingModel);
  
  margin = 1*cm;
  
  base = -beamWidth(squareBeam)+ rodDiam/2+rodMargin;
  top = base + beamWidth(squareBeam);

  beltAttachmentSize = 1*cm;
  
  // Top
  //beam([0,0,top], [carriageLength, 0,top], flatBeam);
  
  // Start and end pieces
  y1 = -(rodDistance/2 + rodDiam/2 + rodMargin);
  y2 = rodDistance / 2- rodDiam/2 - beamHeigth(flatBeam)- margin;
  x1 = -beamWidth(squareBeam)/2;
  x2 = carriageLength-beamWidth(squareBeam)/2 - beamHeigth(squareBeam);
  beam([x1,y1,base], [x1, y2,base], squareBeam, rotation=90);
  beam([x2,y1,base], [x2, y2,base], squareBeam, rotation=90);
  
  // Side
  sideY = y2 + beamHeigth(flatBeam);
  sideBottom = base - (beamWidth(flatBeam) - beamWidth(squareBeam)) / 2;
  sideX1 = -bearingDiam -margin;
  sideX2 = carriageLength;
  beam([sideX1-beltAttachmentSize,sideY,sideBottom], [sideX2, sideY,sideBottom], flatBeam, rotation=90, align=[LEFT,TOP]);
  
  // Side bearings
  bearX1 = sideX1 + bearingDiam/2;
  bearX2 = sideX2 - bearingDiam/2 - beamHeigth(squareBeam) - margin;
  bearY = rodDistance / 2+bearingWidth/2;
  bearZ1 = rodDiam/2+bearingDiam/2;
  bearZ2 = -bearZ1;
  bearing(pos=[bearX1, bearY, bearZ1], model=bearingModel,angle=[90,0,0]);
  bearing(pos=[bearX2, bearY, bearZ1], model=bearingModel,angle=[90,0,0]);
  bearing(pos=[bearX1, bearY, bearZ2], model=bearingModel,angle=[90,0,0]);
  bearing(pos=[bearX2, bearY, bearZ2], model=bearingModel,angle=[90,0,0]);

}








