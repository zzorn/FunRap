/*
 * Beam module.
 * 
 * Originally by Hans Häggström, 2010.
 * Licenced under Creative Commons Attribution-Share Alike 3.0.
 */

<materials.scad>
<units.scad>
<utilities.scad>


// Example, uncomment to view
/*
{
  p1 = [0,0,0]*m;
  p2 = [1,0,0]*m;
  p3 = [1,1,0.25]*m;
  p4 = [0,1,0]*m;

  beam(p1, p2, Beam45x33, align=[CENTER, TOP], material=Birch);
  beam(p2, p3, Beam33x33, align=[RIGHT, TOP], material=Oak);
  beam(p3, p4, Beam70x10, material=Birch);
  beam(p4, p1, Beam45x45, align=[LEFT, TOP], material=Pine, endCaps=[ExtendedCap, CutCap]);
}
*/

// Different beam cross sections (TODO: Add some standard ones?)
Beam33x33 = [33*mm, 33*mm];
Beam45x33 = [45*mm, 33*mm];
Beam45x45 = [45*mm, 45*mm];
Beam70x10 = [70*mm, 10*mm];

function beamWidth(beamType) = beamType[0];
function beamHeigth(beamType) = beamType[1];

module beam(from=[0,0,0], to=[1*m, 0,0], type=Beam45x33, material=Pine, align=[CENTER, TOP], endOffsets=[0,0], endCaps=[FlatCap, FlatCap]) {

  fromTo(from=from, to=to, size=[beamWidth(type), beamHeigth(type)], align=align, material=material, name="Wooden beam", endExtras=endOffsets, endCaps=endCaps) cube();
}





