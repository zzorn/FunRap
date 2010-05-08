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

<parameters.scad>

WoodenRepStrap(machineWidth, machineDepth, machineHeight);

module WoodenRepStrap(xSize, ySize, zSize) {

  baseBeam = frameBeam;
  basePylonSupportOverhang = 5*cm;
  topPylonSupportOverhang = 4*cm;

  topSupportBeamXOffset = xSize * 0.2;

  midY = ySize/2;
  midX = xSize/2;

  translate([-midX, -midY, 0]) 
  {
    Base(xSize, ySize, baseBeam, basePylonSupportOverhang);
    ZStructure(xSize, ySize, zSize, baseBeam);

    
  }

  //------------------------------------------------
  module Base(xs, ys, baseBeam, overhang) {
    echo("Base");

    motorBoardWidth = Beam70x10[0];

    ySlideAreaPos = [baseBeam[0] + motorBoardWidth, 0, baseBeam[1]];
    ySlideAreaSize = [xs - 2*baseBeam[0] - motorBoardWidth, ys, 0];

    beam(xs, baseBeam);
    beam(xs, baseBeam, sideOffset=1, pos=[0,ys,0]);

    beam(ys+2*overhang, baseBeam, pos=[0,-overhang,0], angle=[0,0,90], sideOffset=1, verticalOffset=-1);
    beam(ys+2*overhang, baseBeam, pos=[xs,-overhang,0], angle=[0,0,90], verticalOffset=-1);

    MotorBoard([baseBeam[0],0, baseBeam[1] ], ys);

    translate(ySlideAreaPos) {
      BaseRod(ySlideAreaSize, 0.2);
      BaseRod(ySlideAreaSize, 0.8);
    }


    module BaseRod(ySlideAreaSize, rodPos) {
      rodSpacing = 0*cm;
      rodDiam = 8*mm;

      x = ySlideAreaSize[0]*rodPos;
      y = rodSpacing;

      rod(ySlideAreaSize[1]-rodSpacing*2,diameter=rodDiam, pos=[x, y, rodDiam/2], angle=[0,0,90]);
    } 
  }

  //------------------------------------------------
  module ZStructure(xSize, ySize, zSize, baseBeam) { 
    echo("Z Structure");
    baseSideZ= baseBeam[1]*2;

    midY = ySize/2;
    vertRodZ = baseBeam[1]*1.2;
    guideRodSideDistance = baseBeam[0]/3;
    pylonOvershoot = baseBeam[1] * 1.75;

    nutSpace = 15*mm;

    topZ = zSize - baseBeam[1];
    topL = topBeamDistances + 2*topPylonSupportOverhang;
    pylonTopOffset = topL / 2 - topPylonSupportOverhang;
    pylonHeight = topZ - 2*baseBeam[1];

    ZStructureSide(baseBeam[0]/2, guideRodSideDistance, pylonHeight, pylonTopOffset, topSupportBeamXOffset);
    ZStructureSide(xSize - baseBeam[0]/2, xSize-guideRodSideDistance, pylonHeight, pylonTopOffset, -topSupportBeamXOffset);

    TopRod(topBeamDistances/2);
    TopRod(-topBeamDistances/2);

    module TopRod(offs) {
      threadedRod(xSize, pos=[0, midY+offs, topZ+baseBeam[1]/2], startOffset=nutSpace, endOffset=nutSpace);
    } 

    module ZStructureSide(x, guideX, height, topOffset, topSupportOffset) {
      VerticalGuideRod([guideX, midY, baseSideZ], topZ-baseSideZ);
      Pylon([x, midY, baseBeam[1]*2], midY, topOffset, height, pylonOvershoot); 

      beam(topL, pos=[x, midY-topL/2, topZ], angle=[0,0,90], sideOffset=0.5);
      beam(topL, pos=[x+topSupportOffset, midY-topL/2, topZ], angle=[0,0,90], sideOffset=0.5);

      module Pylon(pos, bottomR, topR, height, over) {
        threadedRodBetweenPoints(from=pos+[0,bottomR,0], to=pos+[topSupportOffset,topR,height], startOffset=over, endOffset=over);
        threadedRodBetweenPoints(from=pos+[0,-bottomR,0], to=pos+[topSupportOffset,-topR,height], startOffset=over, endOffset=over);
      }


      module VerticalGuideRod(position, h){
        rodDiam = 8*mm;
        rod(h, diameter=rodDiam, pos=position, angle=[0,270,0], startOffset=baseBeam[1]*2/3, endOffset=baseBeam[1]*2/3);
      }
  
    }


  }


  //------------------------------------------------
  module MotorBoard(pos, ys) {
    echo("Motorboard");
    motorbeam=platformBeam;
    beam(ys, motorbeam, pos, angle=[0,0,90], sideOffset=1);

    motor(Nema23, pos=pos+[motorbeam[0]/2, ys/3, motorbeam[1]]);
    motor(Nema23, pos=pos+[motorbeam[0]/2, ys*2/3, motorbeam[1]]);
  }
}


