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
p1=[0,0,0]*dm;
p2=[1,0,0]*dm;
p3=[1,1,0.25]*dm;
p4=[0,1,0]*dm;

rod(p1, p2, endCaps=[FlatCap, ExtendedCap]);
threadedRod(p2, p3, endCaps=[CutCap, FlatCap]);
rod(p3, p4, material=Aluminum, endOffsets=[-2*cm, 5*cm]);
rod(p1, p4, align=[CENTER, TOP]);
*/

// Default size
DefaultRodDiameter = 8*mm;

module rod(from=[0,0,0], to=[1*m, 0,0], diameter=DefaultRodDiameter, material=Stainless, align=[CENTER, CENTER], endOffsets=[0,0], endCaps=[FlatCap, FlatCap]) {

  fromTo(from=from, to=to, size=[diameter,diameter], align=[-0.5, 0.5]+align, material=material, name="Rod", endExtras=endOffsets, endCaps=endCaps) {
    rotate([0,90,0]) {
      cylinder(r=0.5, h=1, $fs=diameter/100 );
    }
  }
}

module threadedRod(from=[0,0,0], to=[1*m, 0,0], diameter=DefaultRodDiameter, material=Steel, align=[CENTER, CENTER], endOffsets=[0,0], endCaps=[FlatCap, FlatCap]) {

  fromTo(from=from, to=to, size=[diameter,diameter], align=[-0.5, 0.5]+align, material=material, name="Threaded rod", endExtras=endOffsets, endCaps=endCaps) {
    rotate([0,90,0]) {
      cylinder(r=0.5, h=1, $fs=diameter/60 );
    }
  }
}

