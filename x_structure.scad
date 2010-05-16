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


module XCarriageFrame(xSize, frameBeam, motorBeam=Beam70x10, stepperType=Nema23, rodDiameter = 8*mm, bearingModel=SkateBearing) {
  part("X Carriage Frame");

  rodMarginFromEdges=10*mm;
  
  xRodSeparation = beamWidth(motorBeam) + rodDiameter;

  margin = 1*cm;


  w = beamWidth(frameBeam);
  h = beamHeigth(frameBeam);

  // Rod support beams
  bearRadius = bearingOuterDiameter(bearingModel) / 2;
  rodSep = xRodSeparation/2;
  x2 = xSize - w + rodDiameter + 1.5*rodMarginFromEdges;
  l = rodMarginFromEdges + rodSep + rodDiameter;
  l2 = rodDiameter / 2 + bearRadius + rodMarginFromEdges + 1*cm;
  x2_ = x2 - beamHeigth(motorBeam);
  beam([0,-l,0], [0,l,0], frameBeam, align=[RIGHT, TOP]);
  beam([x2_ ,l,0], [x2_ ,-l,0], frameBeam, align=[RIGHT, TOP]);

  // Bearing slider  
  bearingSliderLength = 80*mm;
  beam([x2,0,0], [x2,0,bearingSliderLength], motorBeam, align=[CENTER, TOP]);

  bOffs = bearRadius + rodDiameter/2;
  bw = bearingWidth(bearingModel);
  bx = xSize - rodMarginFromEdges - rodDiameter/2 - bw/2;
  bz1 = rodMarginFromEdges; 
  bz2 = bearingSliderLength - rodMarginFromEdges; 
  bearing([bx, -bOffs, bz1], angle=[0,90,0], model=bearingModel);
  bearing([bx,  bOffs, bz1], angle=[0,90,0], model=bearingModel);
  bearing([bx, -bOffs, bz2], angle=[0,90,0], model=bearingModel);
  bearing([bx,  bOffs, bz2], angle=[0,90,0], model=bearingModel);
  
  // Rods
  rodX1 = w/3;
  rodX2 = x2;
  rodZ = h + rodDiameter/2;
  rod([rodX1, -rodSep, rodZ], [rodX2, -rodSep, rodZ], diameter=rodDiameter);
  rod([rodX1,  rodSep, rodZ], [rodX2,  rodSep, rodZ], diameter=rodDiameter);

  // Motor
  mbh = beamHeigth(frameBeam);
  mbx1 = -motorWidth(stepperType) - 2*margin;
  mbx2 = w;
  motorX = mbx1 + margin + motorWidth(stepperType) / 2;
  beam([mbx1,0,mbh], [mbx2,0,mbh], motorBeam);
  motor(stepperType, pos=[motorX, 0, mbh], orientation=[180,0,0], dualAxis=true);

  // Moving x carriage
  translate() XCarriageSlide();

}

module XCarriageSlide() {
  part("X Carriage Slide");
}








