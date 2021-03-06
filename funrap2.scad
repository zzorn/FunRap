/*
 * Main file for generating the FunRap model.  
 * Tune the parameters here.
 * 
 * Originally by Hans Häggström, 2010.
 * Licenced under Creative Commons Attribution-Share Alike 3.0.
 */

// Includes
include <units.scad>
include <materials.scad>
include <beam.scad>
include <box.scad>
include <board.scad>
include <rod.scad>
include <stepper.scad>
include <beam.scad>


// Size
width = 50*cm;
depth = 60*cm;
height = 30*cm;
baseThickness = 20*mm;
sideThickness = 10*mm;
rodDiam = 8*mm;

frameBeam = [30*mm, 30*mm];

// Stepper motor
stepperMotorModel = Nema23;
 
// Box 
box([width, depth, height], bottomThickness=baseThickness, sideThickness=sideThickness, topThickness=0,material=Birch);

// Beam Frame 
st = sideThickness;
bt = baseThickness;
beam([st,st,bt], [st,st,height], type=frameBeam, align=[BOTTOM, LEFT]);
beam([width-st,st,bt], [width-st,st,height], type=frameBeam, align=[BOTTOM, RIGHT]);
beam([st,depth-st,bt], [st,depth-st,height], type=frameBeam, align=[TOP, LEFT]);
beam([width-st,depth-st,bt], [width-st,depth-st,height], type=frameBeam, align=[TOP, RIGHT]);

// Rods
r11 = [2.5*cm, 0, height-2.5*cm];
r12 = [2.5*cm, depth, height-2.5*cm];
r21 = [width - 2.5*cm, 0, height-2.5*cm];
r22 = [width - 2.5*cm, depth, height-2.5*cm];
rod(r11, r12, material=Steel, endOffsets=[-sideThickness, -sideThickness], diameter=rodDiam);
rod(r21, r22, material=Steel, endOffsets=[-sideThickness, -sideThickness], diameter=rodDiam);











