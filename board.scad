/*
 * Module for boards and sheets (e.g. MDF, plywood).
 * 
 * Originally by Hans Häggström, 2010.
 * Licenced under Creative Commons Attribution-Share Alike 3.0.
 */

<units.scad>
<materials.scad>

// Example, uncomment to view
/*
board(50*cm, 50*cm);
board(50*cm, 20*cm, angle=[90,0,0]);
*/

boardThickness = 8*mm;

module board(width, height, pos=[0,0,0], angle=[0,0,0], thickness=boardThickness, material=FiberBoard) {
  
  echo("Board ", size[0], "mm x ", size[1], "mm, thickness ",thickness,"mm");

  color(material) {
    translate(pos)
      rotate(angle)
        cube(size=[width, height, thickness]);
  }
}




