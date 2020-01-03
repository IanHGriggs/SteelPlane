module adjustRing(outType){
    source="Assembly.dxf";
    objectName="AdjustRing";
    $fn=64;
  
    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
  
    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
   
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);
    
    module elevationTranslated () {
        translate([-elevationOrigin.x, -elevationOrigin.y,0]) elevation();
    }
    
    module rot1() {rotate([0,0,40]) elevationTranslated();
    }
    
    module solidViewInches() {rotate_extrude() rot1();
    }
    
    // translate and rotate back to original position but in middle of plane on Z.
    module inPosition() { 
        translate([elevationOrigin.x, elevationOrigin.y, (2+1/2+1/8)/2])
        rotate([0, 40, 0]) solidViewInches();
    }
    
    module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
    
    assert(outType != 1);
    if (outType==1) {
        // don't need this because the adjust screw is not cut with waterjet.
        echo("Unneeded projection for waterjet");
        // assert(false);
    } else if (outType==2) {
        // no need to turn upside down.
        solidViewMM();
    } else if (outType==3)  {
        // should figure out correct rotation and translation...
        inPosition();
    } else {
        echo ("InvalidOutType");
    }
  
}
