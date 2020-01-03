module extractRight(outType, objectName, rotateToFlat, thickness) {

    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    planLayer=str(objectName, "_Plan");
    planOriginLayer=str(objectName, "_PlanOrigin");
    $fn=64;
       
    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
    
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);
    
    module elevationTranslated () {translate([-elevationOrigin.x, -elevationOrigin.y,0]) elevation();
    }
    
    module elevationToFlat() {rotate(rotateToFlat) elevationTranslated();
    } 

    module elevationRotated () {rotate([180, 0, 90]) elevationToFlat();
    }
    
    module elevationExtUpright () {linear_extrude(height=4, center=false, convexity=10) elevationRotated();
    }
    
    module elevationExtFlat () {translate([0,4,0])rotate([90,0, 0]) elevationExtUpright();
    }
    
    module plan() {import(source, layer=planLayer, origin=[0,0], scale=1);
    }
    
    planOrigin = dxf_cross (file=source, layer=planOriginLayer, origin=[0,0], scale=1);
    
    module planTranslated () {translate ([-planOrigin.x, - planOrigin.y, 0]) plan();
    }
    
    partWidth = 2+1/2+1/8;
    module planRotated() {translate([0,partWidth,0]) rotate([0,0,rotateToFlat-90]) planTranslated();
    }
    
    module planExt() {linear_extrude(height=thickness, center=false, convexity=10) planRotated();
    }
 
    module solidViewInches () {intersection () {elevationExtFlat(); planExt();
        }
    }
    
    module rotToUpright() {rotate([90,0,0]) solidViewInches();
    }

    module rotToAngle() {rotate([0, 0, 90-rotateToFlat]) rotToUpright();
    }
    
    module inPosition () {translate([elevationOrigin.x, elevationOrigin.y,0]) rotToAngle();}
    
    module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
    
    if (outType==1) {
        projection (cut=false) solidViewInches();
    } else if (outType==2) {
        solidViewMM();
    } else if (outType==3)  {
        inPosition();
    } else {
        echo ("InvalidOutType");
    }
}
