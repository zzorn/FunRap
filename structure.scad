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
<pulley.scad>
<belt.scad>
<stepper.scad>
<y_structure.scad>
<z_structure.scad>

// Uncomment to test:
// FunRap();

module FunRap(xSize=50*cm, ySize=52*cm, zSize=42*cm, frameBeam=Beam45x33, motorBeam=Beam70x10, motorType=Nema23, topSupportSpread=-0.3) {

  time = $t;  // Animated, set to 0..1
  xCarriagePosition = time;
  yCarriagePosition = time;
  zCarriagePosition = time;

  baseSupportExtent = 0; // ySize * 0.075;
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

  motorBoardOffset = [ beamWidth(motorBeam)/2, 0, beamHeigth(frameBeam)];

  yCarriageOffset = motorBoardOffset + [beamWidth(motorBeam)/2,0,0];
  yCarriageSpace = [xSize - 2*beamWidth(motorBeam), ySize];
  yRodOffsets=[2*beamWidth(frameBeam), 2*beamWidth(frameBeam)];

  zCarriageOffset = [0,midY,0];

  rodDistanceFromEdge=8*mm + rodDiameter/2;

  zDriveRodPos1 = [beamWidth(frameBeam)- rodDistanceFromEdge, midY, 0];
  zDriveRodPos2 = [xSize-beamWidth(frameBeam) + rodDistanceFromEdge, midY, 0];

  part("== FunRap ==");

  translate(-baseCenter) 
  {
    // Base
    Base(baseCorners, frameBeam, motorBeam, baseSupportExtent, yRodOffsets);
  
    // Motors
    translate(motorBoardOffset) MotorBoard(ySize, motorBeam, frameBeam, motorType, zDriveRodPos1-motorBoardOffset, zDriveRodPos2-motorBoardOffset);

    // Y carriage
    translate(yCarriageOffset) YCarriageFrame(yCarriageSpace, yRodOffsets, yCarriagePosition, frameBeam, rodDiameter, SkateBearing, motorBeam, motorType);

    // Z carriage
    translate(zCarriageOffset) ZCarriageFrame(xSize, zSize, zCarriagePosition, xCarriagePosition, frameBeam, rodDiameter, zDriveRodPos1-zCarriageOffset, zDriveRodPos2-zCarriageOffset, rodDistanceFromEdge, motorType);

    // Top
    Ridge(topCorners, frameBeam, motorBeam, topSupportExtent, baseCorners, baseSupportExtent, supportRodClearing, supportRodFasteningClearance,rodDiameter);
  }
}


module Base(corners, frameBeam, thinFrameBeam, support, yRodOffsets) {
  part("Base");

  offs=[support, support];
  zOffs = [0,0,beamHeigth(frameBeam)];
  beam(corners[0], corners[1], frameBeam, align=[LEFT, TOP]);
  beam(corners[1]+zOffs, corners[2]+zOffs, thinFrameBeam, align=[LEFT, TOP], endOffsets=offs);
  beam(corners[2], corners[3], frameBeam, align=[LEFT, TOP]);
  beam(corners[3]+zOffs, corners[0]+zOffs, thinFrameBeam, align=[LEFT, TOP], endOffsets=offs);
}


module MotorBoard(length, beamType, frameBeam, motorType, zRod1, zRod2) {
  part("Motor board");

//  beam([0,0,0], [0,length,0], beamType, align=[CENTER, TOP]);

  pos1 = [0, length - beamWidth(frameBeam) - 4*cm, beamHeigth(beamType)];
  motor(model=motorType, pos=pos1);

  p1 = pos1 + [0, 0, -beamHeigth(beamType)];

  pulley(pos=p1, angle=[180,0,0], model=Pulley16x9);

  pulley(pos=[zRod1[0], zRod1[1], -10*mm], angle=[180,0,0], model=Pulley24x9);
  pulley(pos=[zRod2[0], zRod2[1], -10*mm], angle=[180,0,0], model=Pulley24x9);

  beltZ1 = -10*mm;
  beltZ2 = -20*mm;

  midY = length / 2;

  zBeltDrivePos = p1 + [0, 0, beltZ1];
  zBeltTensionerPos = [15*mm, midY + 30*mm, beltZ2];
  zBeltIdlerPos = [-20*mm, midY + 20*mm, beltZ2];
  zDrivePos1 = [zRod1[0], zRod1[1], beltZ2];
  zDrivePos2 = [zRod2[0], zRod2[1], beltZ2];

  zDriveBelt=[zBeltDrivePos, zBeltIdlerPos, zDrivePos1, zDrivePos2, zBeltTensionerPos];

  bearing(pos=zBeltIdlerPos);
  bearing(pos=zBeltTensionerPos);

  belt(5, zDriveBelt, model=TimingBelt_XL_025);  
}


module Ridge(topCorners, frameBeam, flatBeam, topSupportExtent, baseCorners, baseSupportExtent, supportRodClearing, supportRodFasteningClearance, rodDiameter) {
  part("Ridge");

  bw = beamWidth(frameBeam);
  bh = beamHeigth(frameBeam);
  fbh = beamHeigth(flatBeam);

  tb1 = topCorners[0] - [max(supportRodFasteningClearance,topSupportExtent), 0, 0];
  tb2 = topCorners[1] + [max(supportRodFasteningClearance,topSupportExtent), 0, 0];
  beam(tb1, tb2, frameBeam, align=[CENTER, BOTTOM]);

  rodOffs = rodDiameter;

  baseWidthOffs = [bw/2, 0, 0];
  baseHeightOffs = [0, 0, bh + fbh + rodOffs];
  baseSupportOffs = [0, baseSupportExtent + rodOffs, 0];

  topSupportOffs = [topSupportExtent, 0, 0];
  topRodOffs = [supportRodClearing, 0, 0];
  topWidthOffs = [0, -bw/2 -rodOffs, 0];
  topHeigthOffs = [0, 0, rodOffs];

  b1 = baseCorners[0] - baseSupportOffs + baseWidthOffs + baseHeightOffs;
  b2 = baseCorners[1] - baseSupportOffs - baseWidthOffs + baseHeightOffs;
  b3 = baseCorners[2] + baseSupportOffs - baseWidthOffs + baseHeightOffs;
  b4 = baseCorners[3] + baseSupportOffs + baseWidthOffs + baseHeightOffs;

  t1 = topCorners[0] - topSupportOffs + topRodOffs + topWidthOffs + topHeigthOffs;
  t2 = topCorners[1] + topSupportOffs - topRodOffs  + topWidthOffs + topHeigthOffs;
  t3 = topCorners[1] + topSupportOffs - topRodOffs  - topWidthOffs + topHeigthOffs;
  t4 = topCorners[0] - topSupportOffs + topRodOffs  - topWidthOffs + topHeigthOffs;

  fasteningSpace = [supportRodFasteningClearance , 
                    supportRodFasteningClearance ];
  threadedRod(b1, t1, endOffsets=fasteningSpace);
  threadedRod(b2, t2, endOffsets=fasteningSpace);
  threadedRod(b3, t3, endOffsets=fasteningSpace);
  threadedRod(b4, t4, endOffsets=fasteningSpace);
}




