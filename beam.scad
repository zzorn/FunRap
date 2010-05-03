/*
 * Beam module.
 * 
 * Originally by Hans Häggström, 2010.
 * Licenced under Creative Commons Attribution-Share Alike 3.0.
 */

<materials.scad>
<units.scad>

// Example, uncomment to view
/*
{
  beam(1*m, Beam70x10);
  beam(1*m, Beam45x33, [0, 1*m, 0], sideOffset=0.5, verticalOffset=0.5, material=Oak, endCut=Beam33x33[0]);
  beam(1*m, Beam33x33, [1*m, 0, 0], [0,0,90], startCut=Beam70x10[0], material=Birch);
  beam(1*m, Beam45x45, [0, 0, 0], [0,0,90], material=Pine);
}
*/

// Different beam cross sections (TODO: Add some standard ones?)
Beam33x33 = [33*mm, 33*mm];
Beam45x33 = [45*mm, 33*mm];
Beam45x45 = [45*mm, 45*mm];
Beam70x10 = [70*mm, 10*mm];

module beam(length, size=Beam45x33, pos=[0,0,0], angle=[0,0,0], material=Pine, sideOffset=0, verticalOffset=0, startCut=0, endCut=0) {

  l = length - startCut - endCut;

  offset = [startCut, -size[0] * sideOffset, -size[1] * verticalOffset];

  if (l > 0) {
    echo("Wooden beam ", size[0], "mm x ", size[1], "mm, length ",l,"mm");

    color(material) {
      translate(pos) {
        rotate(angle) {
          translate(offset) 
             cube([l, size[0], size[1]]);
        }
      }
    }
  }
}



