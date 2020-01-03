source="Assembly.dxf";
outType=3; // overriden by -D in shell script
include <Throat_Module.scad>;
if (outType==1) {
    // move to 0,0,0 origin for .dxf and .stl
    translate([-(1/4), 0, 0]) throat(1);
} else if (outType==2) {
    // for stl, coordinates are in MM.
    translate([-(25.4*(1/4)),0, 0]) throat(2);
} else if (outType==3) {
      throat(3);
} else {
    assert(false);
}
