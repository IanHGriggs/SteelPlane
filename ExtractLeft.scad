module extractLeft(outType, objectName, rotateToFlat, thickness) {
    
    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    planLayer=str(objectName, "_Plan");
    planOriginLayer=str(objectName, "_PlanOrigin");
    $fn=64;
     
    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
    
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);
    
    module elevationExtUnrotated () {linear_extrude(height=4, center=false, convexity=10) rotate(rotateToFlat) translate([-elevationOrigin.x, -elevationOrigin.y,0]) elevation();
    }
    module elevationExt() {rotate([0, 90, 0]) elevationExtUnrotated();
    }
    
    module plan() {import(source, layer=planLayer, origin=[0,0], scale=1);
    }
    
    planOrigin = dxf_cross (file=source, layer=planOriginLayer, origin=[0,0], scale=1);
    
    module planExt() {linear_extrude(height=.25, center=false, convexity=10) rotate([0,0,rotateToFlat]) translate([-planOrigin.x, - planOrigin.y, 0]) plan();
    }
    
    module solidViewInches () {intersection () {elevationExt(); planExt();
        }
    }
    
    module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
    
    module rotToUpright() {rotate([0,-90,0]) solidViewInches();
    }

    module rotToAngle() {rotate([0, 0, -rotateToFlat]) rotToUpright();
    }
    
    module inPosition () {translate([elevationOrigin.x, elevationOrigin.y,0]) rotToAngle();}
    
    if (outType==1) {
        projection (cut=false) solidViewInches();
    } else if (outType==2) {
        solidViewMM();
    } else if (outType==3) {
        inPosition();
    }
      else {
        echo ("InvalidOutType");
    }
}