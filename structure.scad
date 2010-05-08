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
 FunRap();

module FunRap(xSize=50*cm, ySize=52*cm, zSize=42*cm, frameBeam=Beam45x33, motorBeam=[70,10], motorType=Nema23, topSupportSpread=-0.15) {

  yCarriagePosition = $t; // Animated, set to 0..1
  zCarriagePosition = $t; // Animated, set to 0..1

  baseSupportExtent = ySize * 0.075;
  topSupportExtent = xSize * topSupportSpread;
  supportRodClearing = 3*cm;
  supportRodFasteningClearance = 2*cm;

  rodDiameter = 8*mm;

  midX = xSize/2;
  midY = ySize/2;

  baseCenter = [midX, midY, 0];
  baseCorners=[ [0,0,0], 
                [xSize,0,0], 
                [xSize,ySize,0], 
                [0,ySize,0] ];
  topCorners=[ [0, midY, zSize],
               [xSize, midY, zSize] ];

  motorBoardOffset = [beamWidth(frameBeam) + beamWidth(motorBeam)/2, 0, beamHeigth(frameBeam)];
  motorPositions=[ySize*1/3, ySize*2/3];

  yCarriageOffset = motorBoardOffset + [beamWidth(motorBeam)/2,0,0];
  yCarriageSpace = [xSize - 2*beamWidth(frameBeam) - beamWidth(motorBeam), ySize];
  yRodOffsets=[2*beamWidth(frameBeam), 2*beamWidth(frameBeam)];

  zCarriageOffset = [0,midY,0];

  part("== FunRap ==");

  translate(-baseCenter) 
  {
    // Base
    Base(baseCorners, frameBeam, baseSupportExtent, yRodOffsets);
  
    // Motors
    translate(motorBoardOffset) MotorBoard(ySize, motorBeam, motorType, motorPositions);

    // Y carriage
    translate(yCarriageOffset) YCarriageFrame(yCarriageSpace, yRodOffsets, yCarriagePosition, frameBeam, rodDiameter);

    // Z carriage
    translate(zCarriageOffset) ZCarriageFrame(xSize, zSize, zCarriagePosition, frameBeam, rodDiameter);

    // Top
    Ridge(topCorners, frameBeam, topSupportExtent, baseCorners, baseSupportExtent, supportRodClearing, supportRodFasteningClearance);
  }
}


module Base(corners, frameBeam, support, yRodOffsets) {
  part("Base");

  offs=[support, support];
  beam(corners[0], corners[1], frameBeam, align=[LEFT, TOP]);
  beam(corners[1], corners[2], frameBeam, align=[LEFT, TOP*3], endOffsets=offs);
  beam(corners[2], corners[3], frameBeam, align=[LEFT, TOP]);
  beam(corners[3], corners[0], frameBeam, align=[LEFT, TOP*3], endOffsets=offs);
}


module MotorBoard(length, beamType, motorType, motorPositions) {
  part("Motor board");

  beam([0,0,0], [0,length,0], beamType, align=[CENTER, TOP]);

  pos1 = [0, motorPositions[0], beamHeigth(beamType)];
  pos2 = [0, motorPositions[1], beamHeigth(beamType)];
  motor(model=motorType, pos=pos1);
  motor(model=motorType, pos=pos2);

}


module Ridge(topCorners, frameBeam, topSupportExtent, baseCorners, baseSupportExtent, supportRodClearing, supportRodFasteningClearance) {
  part("Ridge");

  bw = beamWidth(frameBeam);
  bh = beamHeigth(frameBeam);

  extraLen = length2([bw, bh]) / 2;

  tb1 = topCorners[0] - [max(0,topSupportExtent), 0, 0];
  tb2 = topCorners[1] + [max(0,topSupportExtent), 0, 0];
  beam(tb1, tb2, frameBeam, align=[CENTER, BOTTOM]);

  baseWidthOffs = [bw/2, 0, 0];
  baseHeightOffs = [0, 0, 1.5*bh];
  baseSupportOffs = [0, baseSupportExtent - supportRodClearing, 0];
  topSupportOffs = [topSupportExtent, 0, 0];
  topRodOffs = [supportRodClearing, 0, 0];
  topWidthOffs = [0, 0, 0];
  topHeigthOffs = [0, 0, -bh/2];

  b1 = baseCorners[0] - baseSupportOffs + baseWidthOffs + baseHeightOffs;
  b2 = baseCorners[1] - baseSupportOffs - baseWidthOffs + baseHeightOffs;
  b3 = baseCorners[2] + baseSupportOffs - baseWidthOffs + baseHeightOffs;
  b4 = baseCorners[3] + baseSupportOffs + baseWidthOffs + baseHeightOffs;

  t1 = topCorners[0] - topSupportOffs + topRodOffs + topWidthOffs + topHeigthOffs;
  t2 = topCorners[1] + topSupportOffs - topRodOffs  + topWidthOffs + topHeigthOffs;
  t3 = topCorners[1] + topSupportOffs - 2*topRodOffs  - topWidthOffs + topHeigthOffs;
  t4 = topCorners[0] - topSupportOffs + 2*topRodOffs  - topWidthOffs + topHeigthOffs;

  fasteningSpace = [supportRodFasteningClearance + extraLen, 
                    supportRodFasteningClearance + extraLen];
  threadedRod(b1, t1, endOffsets=fasteningSpace);
  threadedRod(b2, t2, endOffsets=fasteningSpace);
  threadedRod(b3, t3, endOffsets=fasteningSpace);
  threadedRod(b4, t4, endOffsets=fasteningSpace);
}


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

  module YCarriageSlide(surfaceSize) {
    part("Y Carriage Slide");
    board(size=surfaceSize);  
  }
}





module ZCarriageFrame(xSize, zSize, zCarriagePosition, frameBeam, rodDiameter) {
  part("Z Carriage Frame");

  rodDistanceFromEdge=10*mm + rodDiameter/2;
  movementMargin = 10*mm;
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
  tr1s = [beamWidth(frameBeam) - rodDistanceFromEdge,0,trs];
  tr1e = [beamWidth(frameBeam) - rodDistanceFromEdge,0,tre];
  tr2s = [xSize-beamWidth(frameBeam) + rodDistanceFromEdge,0,trs];
  tr2e = [xSize-beamWidth(frameBeam) + rodDistanceFromEdge,0,tre];
  threadedRod(tr1s, tr1e, diameter=rodDiameter);
  threadedRod(tr2s, tr2e, diameter=rodDiameter);



  carriageMovement = [2*beamHeigth(frameBeam) + movementMargin, 
              zSize - beamHeigth(frameBeam) - movementMargin - slideHeight];

  travel = carriageMovement[1]-carriageMovement[0];

  echo(str("  --- Build area along Z axis: ", travel, " mm ---"));

  carriagePos = [0,0,zCarriagePosition * travel + carriageMovement[0]];

  translate(carriagePos) ZCarriageSlide(xSize);

  module ZCarriageSlide(carriageLength) {
    part("Z Carriage Slide");
    %beam([0,0,0], [carriageLength, 0,0], align=[CENTER, TOP]);
  }
}








