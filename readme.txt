== FunRap ==

FunRap is a design for a RepStrap (home buildable 3D printer) made from wooden beams and metal rods.

It is loosely based on the RepRap Mendel design (see http://www.reprap.org for details on the Mendel).


== Goals ==

Fun in FunRap comes from Functionalism, which is the architectural design principle applied, and Functional, as in parametrizable design, and of course Fun, cause it's supposed to be that to configure it and put it together :)

The goals of the design are:

  * Keep the design simple
  * Keep construction easy
  * Keep material costs low
  * Keep the machine functional  

The design is (currently) implemented in OpenSCAD, which is like a CAD programming language  This allows easy tweaking of different parameters of the design (e.g. switching the wooden beam sizes used, etc).


== Features ==

You can funrap.scad in OpenSCAD (or a text editor) and tune the paramters and materials to fit your available resources and desired build area.

When you generate the 3D preview in OpenSCAD, the scripts will create a list of the parts used in the log window, specifying sizes, lenghts, models, and so on for each pice.


== Usage ==

You need OpenSCAD installed to use this design.
You can get it here: http://openscad.org/
OpenSCAD can also export to the STL format.

funrap.scad is the main file that uses the others to construct the repstrap.


== OpenSCAD library files ==

Feel free to copy OpenSCAD files for reuse elsewhere, there is for example a parametrizable Nema Stepper motor model as well as some other potentially useful stuff.


== Licence ==

The files are licenced under Creative Commons Attribution-Share Alike 3.0., but feel free to ask if you need them under some other license.


== Contact ==

zzorn at iki dot fi

