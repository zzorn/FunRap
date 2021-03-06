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
include <stepper.scad>
include <structure.scad>


// Size
machineWidth = 50.5*cm;
machineDepth = 52.5*cm;
machineHeight = 43.9*cm;

// Size of wooden beams used
frameBeam = [45*mm, 33*mm];
motorPlatformBeam = [70*mm, 10*mm];

// Stepper motor
stepperMotorModel = Nema23;

// Support configuration 
// (How far out the ends of the top support should be, 
//  expressed in fraction of machine width.
//  Use a negative value to put the top ends of the supports inside the machine).
topSupportSpread = -0.3;


// Create the model
FunRap( xSize=machineWidth, 
        ySize=machineDepth, 
        zSize=machineHeight, 
        frameBeam=frameBeam, 
        motorBeam=motorPlatformBeam, 
        motorType=stepperMotorModel,
        topSupportSpread=topSupportSpread);

