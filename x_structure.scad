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


module XCarriageFrame(xSize, xPos = 0.3, frameBeam, rodDistanceFromEdge, motorBeam=Beam70x10, stepperType=Nema23, rodDiameter = 8*mm, bearingModel=SkateBearing) {
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
  idlerSpace = bearRadius * 2;
  mbh = beamHeigth(frameBeam) + baseZ;
  mbx1 = 0 - motorWidth(stepperType) - idlerSpace;
  mbx2 = w;
  motorX = - motorWidth(stepperType) / 2;
  beam([mbx1,0,mbh], [mbx2,0,mbh], motorBeam);
  motorPos = [motorX, 0, mbh];
  motor(stepperType, pos=motorPos, orientation=[180,0,0]);

  // Idlers for cable
  cableZ = mbh+beamHeigth(motorBeam) + 12 * mm;
  motorIdlerX1 = mbx1 + idlerSpace / 2;
  motorIdlerX2 = x2 - w + margin;
  motorIdlerY = xRodSeparation / 2 - bearRadius - margin/2;
  motorIdler1 = [motorIdlerX1,   motorIdlerY, cableZ];
  motorIdler2 = [motorIdlerX1,  -motorIdlerY, cableZ];
  motorIdler3 = [motorIdlerX2,   motorIdlerY, cableZ];
  motorIdler4 = [motorIdlerX2,  -motorIdlerY, cableZ];
  bearing(pos=motorIdler1, model=bearingModel);
  bearing(pos=motorIdler2, model=bearingModel);
  bearing(pos=motorIdler3, model=bearingModel);
  bearing(pos=motorIdler4, model=bearingModel);

  // Pulley
  pulleyModel = Pulley16x9;
  pulleyPos =motorPos+[0,0,beamHeigth(motorBeam) + 1*mm]; 
  pulley(pos=pulleyPos, model=pulleyModel);

  // Moving x carriage
  movementMargin1 = 5*mm;
  movementMargin2 = 8.6*mm + beamWidth(frameBeam);
  carriageLength = 9.5*cm;
  movementInterval = [mbx2 + movementMargin1, xSize - carriageLength - movementMargin2];
  travel = movementInterval[1] - movementInterval[0];
  carriageX = movementInterval[0] + xPos * travel;
  echo(str("  --- Build area along X axis: ", travel, " mm ---"));
  translate([carriageX, 0, mbh+rodDiameter/2]) XCarriageSlide(motorBeam, frameBeam, xRodSeparation, rodDiameter, rodDistanceFromEdge, bearingModel, carriageLength);

  // Belt
  cz = [0,0,4*mm];
  beltDrivePos = [pulleyPos[0], pulleyPos[1], cableZ]+cz;
  carriageBeltConnect1 = [carriageX+20*mm, motorIdlerY+3*mm, cableZ] + cz;
  carriageBeltConnect2 = [carriageX+carriageLength-20*mm, motorIdlerY+3*mm, cableZ] + cz;

  belt(7, [carriageBeltConnect1, motorIdler1+cz, beltDrivePos, motorIdler2+cz, motorIdler4+cz, motorIdler3+cz, carriageBeltConnect2], model=TimingBelt_XL_025, closed=false);

}

module XCarriageSlide(flatBeam, squareBeam, rodDistance, rodDiam, rodMargin, bearingModel=SkateBearing, carriageLength=12*cm,  ) {
  part("X Carriage Slide");
  
  bearingDiam =  bearingOuterDiameter(bearingModel);
  bearingWidth =  bearingWidth(bearingModel);
  
  margin = 1*cm;
  
  base = -beamWidth(squareBeam)+ rodDiam/2+rodMargin;
  top = base + beamWidth(squareBeam);

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
  sideX1 = 0;
  sideX2 = carriageLength;
  beam([sideX1,sideY,sideBottom], [sideX2, sideY,sideBottom], flatBeam, rotation=90, align=[LEFT,TOP]);
  
  // Side bearings
  bearX1 = beamHeigth(squareBeam)/2;
  bearX2 = carriageLength -beamHeigth(squareBeam)/2;
  bearY = rodDistance / 2+bearingWidth/2;
  bearZ1 = rodDiam/2+bearingDiam/2;
  bearZ2 = -bearZ1;
  bearing(pos=[bearX1, bearY, bearZ1], model=bearingModel,angle=[90,0,0]);
  bearing(pos=[bearX2, bearY, bearZ1], model=bearingModel,angle=[90,0,0]);
  bearing(pos=[bearX1, bearY, bearZ2], model=bearingModel,angle=[90,0,0]);
  bearing(pos=[bearX2, bearY, bearZ2], model=bearingModel,angle=[90,0,0]);

}








