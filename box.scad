/*
 A box made out of boards on the sides.
*/

include <units.scad>
include <materials.scad>
include <beam.scad>
include <board.scad>

module box(size=[10*cm, 10*cm, 10*cm], pos=[0,0,0], angle=[0,0,0], bottomThickness=boardThickness, topThickness=boardThickness, sideThickness=boardThickness, material=FiberBoard, includeBottom=true, includeTop=false) {

  w = size[0];
  d = size[1];
  h = size[2];
  boT = bottomThickness;
  toT = topThickness;
  sT = sideThickness;
  sH = h - boT - toT;

    translate(pos)
      rotate(angle) {

        if (includeBottom) {
          board([w, d], thickness=boT, material=material);
        }

        if (includeTop) {
          board([w, d], pos=[0,0,h-toT], thickness=toT, material=material);
        }

        board([w-2*sT, sH], pos=[sT,sT,boT],  angle=[90,0,0],  thickness=sT, material=material);
        board([w-2*sT, sH], pos=[sT,d,boT],   angle=[90,0,0],  thickness=sT, material=material);
        board([d,      sH], pos=[0,0,boT],    angle=[90,0,90], thickness=sT, material=material);
        board([d,      sH], pos=[w-sT,0,boT], angle=[90,0,90], thickness=sT, material=material);


      }

}

 



