/*
 * Module for rods and threaded rods.
 * 
 * Originally by Hans Häggström, 2010.
 * Licenced under Creative Commons Attribution-Share Alike 3.0.
 */

<units.scad>
<materials.scad>
<utilities.scad>

// Example, uncomment to view
/*
rod();
threadedRod(50*cm, diameter= 12*mm, angle=[0,0,90], startOffset=5*cm);
rodBetweenPoints([50*cm, 0*cm, 0*cm], [0*cm, 50*cm, 0*cm]);
*/

// Default size
DefaultRodDiameter = 8*mm;

module threadedRodBetweenPoints(from=[0,0,0], to=[0,0,0], diameter=DefaultRodDiameter, material=Steel, startOffset=0, endOffset=0) {

  l = distance(from, to);
  angle = angleBetweenTwoPoints(from, to);

  threadedRod(l, from, angle, diameter, material, startOffset, endOffset);
}

module threadedRod(length=1*m, pos=[0,0,0], angle=[0,0,0], diameter=DefaultRodDiameter, material=Steel, startOffset=0, endOffset=0) {
  l = length + startOffset + endOffset;

  echo("Threaded rod, ", diameter, "mm diameter, ", l, "mm long.");

  _rodCylinder(l, pos, angle, diameter, material, startOffset, endOffset);
}


module rodBetweenPoints(from=[0,0,0], to=[0,0,0], diameter=DefaultRodDiameter, material=Steel, startOffset=0, endOffset=0) {

  l = distance(from, to);
  angle = angleBetweenTwoPoints(from, to);

  rod(l, from, angle, diameter, material, startOffset, endOffset);
}

module rod(length=1*m, pos=[0,0,0], angle=[0,0,0], diameter=DefaultRodDiameter, material=Steel, startOffset=0, endOffset=0) {
  l = length + startOffset + endOffset;

  echo("Plain rod, ", diameter, "mm diameter, ", l, "mm long.");

  _rodCylinder(l, pos, angle, diameter, material, startOffset, endOffset);
}

// Helper
module _rodCylinder(length, pos, angle, diameter, material, startOffset, endOffset) {
  color(material){
    translate(pos)
      rotate(angle) 
        rotate([0,90,0]) 
          translate([0, 0, -startOffset])
            cylinder(r = diameter * 0.5, h = length, $fs=diameter/12);
  }
}

