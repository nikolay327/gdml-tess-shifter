# gdml-tess-shifter

A specialized tool for editing vertex information of a tessellated solid contained in a GDML file containing only one tessellated solid.
The aim is to move the center of mass of the tessellated solid to the origin. This is done to avoid problems when generating vertices
in a Monte Carlo simulation inside the geometry.

To use, source `./src/shift-coord.sh`.
To run, execute `shift-coord /path/to/gdmlfile/to/be/read /path/to/gdmlfile/to/be/written dx dy dz`
