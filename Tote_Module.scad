module tote(outType) {
    source="Assembly.dxf";
    objectName="Tote";
    
    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    $fn=64;
    
    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
    
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);
    
    module elevationTranslated () {translate([-elevationOrigin.x, -elevationOrigin.y,0]) elevation();
    }
    // Extrude in position.
    toteThickness = 1;
    totalWidth = 2 + 1/2 + 1/8;
    
    module elevationExt () {linear_extrude(height=toteThickness, center=false, convexity=10) elevation();
    }
    // Translate up Z axis to middle of sole, leaving in position on X and Y axes
    upAxis = (totalWidth/2) - (toteThickness/2);
    module elevUpZ() {translate([0,0,upAxis]) elevationExt();
    }
    
    // subtract the tote bolts which are returned by module in position.
    include <ToteBolt_Module.scad>;
    include <ToteMidBolt_Module.scad>;
    module bolt1() {toteBolt(3);}
    module bolt2() {toteMidBolt(3);}
    
    module inPosition() {
        difference() {elevUpZ(); bolt1(); bolt2();}
    }    
    
    // Translate back to position appropriate for 3D printing
    module solidViewInches() { 
        translate([-elevationOrigin.x, -elevationOrigin.y, -upAxis]) inPosition();
    };
   
    module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
    
    if (outType==1) {
        // no need for waterjet profile.
        echo ("Wrong outType");
    } else if (outType==2) {
        solidViewMM();
    } else if (outType==3) {
        inPosition();
    } else {
        echo ("InvalidOutType");
    }
}
