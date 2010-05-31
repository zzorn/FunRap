/*
 * Timing belt module.
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
  p1 = [0,0,0]*dm;
  p2 = [1,0,0]*dm;
  p3 = [1,1,0.5]*dm;
  p4 = [0,1,0]*dm;

  r1 = 20*mm;
  r2 = 50*mm;
 
  points = [p1, p2, p3, p4];

  belt(4, points, TimingBelt_XL_025, closed=true);
}
*/

// Different beam cross sections (TODO: Add some standard ones?)
BELT_WIDTH = 0;
BELT_THICKNESS = 1;

POINT_POS = 0;
POINT_RADIUS = 1;

TimingBelt_XL_025 = [0.25*inch, 0.1*inch];
TimingBelt_XL_038 = [0.38*inch, 0.1*inch];

function sectionLen(i, numpoints, points) = (i <= numpoints-2) ? distance(points[i], points[i+1]) : 0; 

module belt(numpoints, points, model = TimingBelt_XL_025, material=BlackPaint, closed=true, rotation = 0) {

  // NOTE: There is no way to recurse or loop & assign to a variable in OpenScad, so we can not calculate sums of arbitary number of elements...  Fail!
  length = sectionLen(0, numpoints, points) +
           sectionLen(1, numpoints, points) +
           sectionLen(2, numpoints, points) +
           sectionLen(3, numpoints, points) +
           sectionLen(4, numpoints, points) +
           sectionLen(5, numpoints, points) +
           sectionLen(6, numpoints, points) +
           sectionLen(7, numpoints, points) +
           sectionLen(8, numpoints, points) +
           sectionLen(9, numpoints, points) +
           sectionLen(10, numpoints, points) +
           sectionLen(11, numpoints, points) +
           sectionLen(12, numpoints, points) +
           sectionLen(13, numpoints, points) +
           sectionLen(14, numpoints, points) +
           sectionLen(15, numpoints, points) +
           sectionLen(16, numpoints, points) +
           (closed ? distance(points[numpoints-1], points[0]) : 0);

  if (numpoints <= 16) {
    echo(str("  Belt ", model[BELT_WIDTH], "mm wide, ", length ,"mm long, not counting pulley radiuses", (closed ? ", looped" : ", open-ended")));
  }
  if (numpoints > 16) {
    echo(str("  Belt ", model[BELT_WIDTH], "mm wide, unknown length", (closed ? ", looped" : ", open-ended")));
  }
  

  from = points[0];
  to = points[1];
  i2 = numpoints-1;

  for(i = [0 : i2]) {
    assign(from = points[i], to = points[i + 1]) {    
      fromTo(from=from, to=to, size=[model[BELT_THICKNESS], model[BELT_WIDTH]], material=material, printString=false, rotation=[rotation, 0,0]) cube();
    }
  }

  if (closed && numpoints > 1) {
    fromTo(from=points[numpoints-1], to=points[0], size=[model[BELT_THICKNESS], model[BELT_WIDTH]], material=material, printString=false, rotation=[rotation, 0,0]) cube();
  } 
}




