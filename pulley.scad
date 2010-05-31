/*
 * A nema standard stepper motor module.
 * 
 * Originally by Hans Häggström, 2010.
 * Licenced under Creative Commons Attribution-Share Alike 3.0.
 */

<units.scad>
<materials.scad>

// Example:
/*
pulley(model=Pulley16x9);
*/

PULLEY_BORE_DIAMETER = 0;
PULLEY_DIAMETER = 1;
PULLEY_FLANGE_DIAMETER = 2;
PULLEY_BELT_WIDTH = 3;
PULLEY_EXTRUSION_WIDTH = 4;

Pulley16x9 = [6.3*mm, 16*mm, 22*mm, 11.3*mm, 6*mm];
Pulley24x9 = [8*mm, 24*mm, 30*mm, 11.3*mm, 6*mm];


module pulley(pos=[0,0,0], angle=[0,0,0], model=Pulley16x9, material=BlackPaint, holeMaterial=Aluminum) {

  echo(str("  Pulley, internal diameter ", model[PULLEY_BORE_DIAMETER], ", belt diameter ", model[PULLEY_DIAMETER]));

  holeR = model[PULLEY_BORE_DIAMETER] / 2;
  pulleyR = model[PULLEY_DIAMETER] / 2;
  flangeR = model[PULLEY_FLANGE_DIAMETER] / 2;

  beltW = model[PULLEY_BELT_WIDTH];
  extrusionW = model[PULLEY_EXTRUSION_WIDTH];
  flangeW = 1*mm;

  f1 = extrusionW;
  f2 = extrusionW + beltW + flangeW;

  w = extrusionW + beltW + 2 * flangeW;

  translate(pos) {
    rotate(a=angle) {
      difference() {
        color(material)  {
          cylinder(r=pulleyR, h=w,  $fs = 0.01);
          translate([0,0,f1]) cylinder(r=flangeR, h=flangeW,  $fs = 0.01);
          translate([0,0,f2]) cylinder(r=flangeR, h=flangeW,  $fs = 0.01);
        } 
        color(holeMaterial)  {
          translate([0,0,-epsilon]) cylinder(r=holeR, h=w+2*epsilon,  $fs = 0.01);
        }
      }
    }
  }


}

