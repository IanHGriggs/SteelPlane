// AdjustHolder is just flat, no need for elevation to form bevels.
module adjustHolder(outType) {
    source="Assembly.dxf";
    objectName="AdjustHolder";
    rotateToFlat=[0,0,-50];
    thickness=1/4;
    
    planLayer=str(objectName, "_Plan");
    planOriginLayer=str(objectName, "_PlanOrigin");
    $fn=64;
    
    module plan() {import(source, layer=planLayer, origin=[0,0], scale=1);
    }
    
    planOrigin = dxf_cross (file=source, layer=planOriginLayer, origin=[0,0], scale=1);
    
    module planTranslated () {translate([-planOrigin.x, - planOrigin.y, 0]) plan();
    }
    module planRotated() {rotate(rotateToFlat) planTranslated();
    }
    module planExt() {linear_extrude(height=.25, center=false, convexity=10) planRotated();
    } 
     
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);
    
    module solidViewInches () { planExt();
    }
    
     module rotToUpright() {translate([1/4, 0, 0]) rotate([0,-90,0]) solidViewInches();
    }
        
    module rotToAngle() {rotate([0, 0, -rotateToFlat.z]) rotToUpright();
    }
    
    module inPosition () {translate([elevationOrigin.x, elevationOrigin.y,0]) rotToAngle();
    }
    
    module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
    
    if (outType==1) {
        // echo ("outType=", outType);
        projection (cut=false) solidViewInches();
    } else if (outType==2) {
        solidViewMM();
    } else if (outType==3) {
       inPosition(); 
    } else {
        echo ("InvalidOutType");
    }
}