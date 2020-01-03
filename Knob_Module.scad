module knob(outType){
    objectName="Knob";
    source="Assembly.dxf";
    $fn=64;    
    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    
    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
   
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);

   
    //elevationTranslated();
    // Extrude the knob, in place, up to width of plane.
    module elevationExt() {
        translate([0,0,-.001]) 
        linear_extrude(height=(2+1/2+1/8), center=false, convexity=10)
        elevation();
    }
    
    // fetch the pieces that are cut out of the knob.
    // They need to be a bit bigger than the knob so that 
    // there is no ambiguity about surfaces.
    
    include <ThroatHolder_Module.scad>;
    include <Side_Module.scad>;
    include <ToteFrontBolt_Module.scad>;
    
    module rightSide() {side(3);}
    module rightPadded() {translate([0,0,-1/4]) scale([1,1,2]) rightSide();};
    
    module leftPadded() {translate([0,0,2+1/8+1/2
        ]) rightPadded();}
    
    module throatHull() { translate([0,0,-1/2]) scale([1,1,2]) hull() throatHolder(3);};
    
    module inPosition() {difference() {elevationExt(); hull() throatHull(); leftPadded(); rightPadded(); toteFrontBolt(3);};
    }
    
    module elevationTranslated () {
        translate([-elevationOrigin.x, -elevationOrigin.y,0]) inPosition();
    } 
    
    if (outType==1) {
        echo ("Do not need dxf for knob, which is not waterjet cut.");
    } else if (outType==2) {
        scale([25.4,25.4,25.4]) elevationTranslated();
    } else if (outType==3) {
        inPosition();
    } else {
        echo ("Invalid outType=", outType);
    }
}

