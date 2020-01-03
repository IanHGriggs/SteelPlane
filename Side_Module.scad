source="Assembly.dxf";
module side(outType) {
include <ThroatHolder_Module.scad>;
module throatHolderUpright () {throatHolder(3);}
// Stretch to ensure tenons are longer than thickness of side plate.
module throatHolderUprightScaled() {translate([0,0, -.125]) scale([1,1,3]) throatHolderUpright();
}

include <Frog_Module.scad>;
module frogUpright () {frog(3);}
module frogUprightScaled() {translate([0,0, -.125]) scale([1,1,3]) frogUpright();
}

include <AdjustHolder_Module.scad>;
module adjustHolderUpright() {adjustHolder(3);
    }
module adjustHolderUprightScaled() {translate([0,0, -.125]) scale([1,1,3]) adjustHolderUpright();
}

include <SoleFront_Module.scad>;
module soleFrontUpright() {soleFront(3);}
module soleFrontUprightScaled() {translate([0,0, -.125]) scale([1,1,3]) soleFrontUpright();
}

include <SoleRear_Module.scad>;
module soleRearUpright() {soleRear(3);}
module soleRearUprightScaled() {translate([0,0, -.125]) scale([1,1,3]) soleRearUpright();
}

module slabPiece() { translate([-3, -.25, 0]) color ("Pink") cube(size=[8, 3,.25], center=false);
}
module tenonUnion() {union() {
    frogUprightScaled(); 
    throatHolderUprightScaled();
    adjustHolderUprightScaled();
    soleFrontUprightScaled();
    soleRearUprightScaled();}
}
module slabMinusTenons () { difference() {slabPiece(); 
    tenonUnion();}
}


sideLayer = "Side_Elevation";
module sideElevation () {import(source, layer=sideLayer, origin=[0,0], scale=1) ;
    }

// sideElevation();
// Make the side a little fatter in elevation to
// ensure a 2-manifold later.
module sideExt () {translate([0, 0, -.25]) 
    linear_extrude(height=3/4, center=false, convexity=10,$fn=32) sideElevation();
}

// Intersect, forming side minus tenon holes.
module solidViewInches() {intersection() {
    slabMinusTenons(); sideExt();}
}

 module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
 if (outType==1) {
    projection (cut=false) solidViewInches();
} else if (outType==2) {
    solidViewMM();
} else if (outType==3)  {
    // The side is already in position since it was never translated away.
    solidViewInches();
} else if (outType==4) {
    // produce mirror image for right side
    projection (cut=false) mirror(0,1,0) solidViewInches();    
} else {
    echo ("InvalidOutType");
}
}
