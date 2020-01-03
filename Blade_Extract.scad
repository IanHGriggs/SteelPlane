source="Assembly.dxf";
include <Blade_Module.scad>;
// For the DXF for water jet and the .stl for 3D printing,
// move the blade to up against the x axis.
// 1/4" side + 1/16 clearance.
outType=2;
if (outType==1) {
    translate([0, -(1/4+1/16), 0]) blade(1);
} else if (outType==2) {
    // for stl, coordinates are in MM.
    
    translate([0, -(25.4*(5/16)), 0]) blade(2);
} else if (outType==3) {
      blade(3);
} else {
    assert(false);
}
