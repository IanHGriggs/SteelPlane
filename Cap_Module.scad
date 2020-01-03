module cap(outType) {
    // The cap has bevels on the top, not the bottom, so
    // it needs a slightly different extract pattern.
    // It is not tenoned in to sides, so inPosition is
    // not required.
    
    source="Assembly.dxf";
    objectName="Cap";
    rotateToFlat=[0,0,40];
    thickness=1/8;
    
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
    
    module elevationRotated () {rotate([0, 180, 0]) elevationToFlat();
    }
    
    module elevationExtUpright () {linear_extrude(height=4, center=false, convexity=10) elevationToFlat();
    }
    
    module elevationExtFlat () {rotate([0, 90, 0]) elevationExtUpright();
    }
    
    module plan() {import(source, layer=planLayer, origin=[0,0], scale=1);
    }
    
    planOrigin = dxf_cross (file=source, layer=planOriginLayer, origin=[0,0], scale=1);
    
    module planTranslated () {translate([-planOrigin.x, - planOrigin.y, 0]) plan();
    }
    module planRotated() {rotate(rotateToFlat) planTranslated();
    }
    module planExt() {linear_extrude(height=.25, center=false, convexity=10) planRotated();
    } 
    module solidViewInches () {intersection () {elevationExtFlat(); planExt();
        }
    }
    module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
    
    if (outType==1) {
        projection (cut=false) solidViewInches();
    } else if (outType==2) {
        solidViewMM();
    } else {
        echo ("InvalidOutType");
    }
}
