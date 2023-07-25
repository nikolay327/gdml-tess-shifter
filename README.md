# gdml-tess-shifter

A specialized tool for editing vertex information of all tessellated solids contained in a GDML file.
The aim is to move the center of mass of the tessellated solids to the origin. This is done to avoid problems with the bounding box when generating vertices
in a Monte Carlo simulation inside the geometry. Additionally, rotations are also possible.<br />

To use, source `./src/shift-coord.sh` and `./src/rotate-coord.sh`.<br />

## Available commands
- `shift-coord`. Example: `shift-coord /path/to/gdmlfile/to/be/read /path/to/gdmlfile/to/be/written dx dy dz`
- `rotate-coord`. Example: `rotate-coord /path/to/gdmlfile/to/be/read /path/to/gdmlfile/to/be/written phix phiy phiz`
