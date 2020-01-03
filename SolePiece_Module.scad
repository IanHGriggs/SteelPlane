module solePiece(outType, objectName) {
    // Special handling for tail cutouts
    
    source="Assembly.dxf";
    thickness=1/4;
    $fn=64;
   
    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    planLayer=str(objectName, "_Plan");
    planOriginLayer=str(objectName, "_PlanOrigin");
    pinsLayer=str(objectName, "_Pins");
    planWidth =  2+1/2+ 1/8;
     
    module plan() {import(source, layer=planLayer, origin=[0,0], scale=1);
    }
      planOrigin = dxf_cross (file=source, layer=planOriginLayer, origin=[0,0], scale=1);
    
    module planTranslated () {translate([-planOrigin.x, - planOrigin.y, 0]) plan();
    }
     
     module planExt() {linear_extrude(height=.25, center=false, convexity=10) planTranslated();
    }
    
     module planExtRot() {rotate([-90,0,0]) planExt();
     }
     
    module pins() {import(source, layer=pinsLayer, origin=[0,0], scale=1);
    }
     module pinsTranslated() {translate([-elevationOrigin.x, - elevationOrigin.y, 0]) pins();
    }
    module pinsExt() {linear_extrude(height=.25, center=false, convexity=10) pinsTranslated();
    }
     
    module planMinusPins() {difference() {planExtRot(); pinsExt();}
}

    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
    
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);
    
    module elevationTranslated () {translate([-elevationOrigin.x, -elevationOrigin.y,0]) elevation();
    }

    module elevationExtUpright () {linear_extrude(height=4, center=false, convexity=10) elevationTranslated();
    }
    
    module elevationDown() {translate([0,0,-.5]) elevationExtUpright();
    }
    
    module planIntersectElevation() {intersection() { planMinusPins(); elevationDown();}
    }
    
    module uprightViewUpper() {translate([0, 0, planWidth]) mirror([0,0,1]) planIntersectElevation();
    }
    module uprightUnion() {union() {planIntersectElevation(); uprightViewUpper();}
    }

    module solidViewInches() {
       rotate([-90, 0, 0]) 
        rotate([0,0,180]) uprightUnion();
    }
    
    module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
  
    if (outType==1) {
        projection (cut=false) solidViewInches();
    } else if (outType==2) {
        solidViewMM();
    } else if (outType==3) {
        // shift back to original position
        translate([0, .25, 0]) translate ([planOrigin.x, planOrigin.y, 0])uprightUnion();
    } else {
        echo ("InvalidOutType");
    }
    
}
