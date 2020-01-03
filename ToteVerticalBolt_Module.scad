module toteVerticalBolt(outType, objectName) {
    source="Assembly.dxf";
    $fn=64;    
    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    // elevationTopOriginLayer=str(objectName, "_ElevationTopOrigin");
    
    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
   
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);

    module elevationTranslated () {
        translate([-elevationOrigin.x, -elevationOrigin.y,0]) elevation();
    }
    
    // trim a bit so the 2D shape lies completely on one side of the X axis.
    module trimBit() { square(size=[.0001, 4], center=false);
    }
    
    module rot2() { difference() {elevationTranslated(); trimBit();};
    }
    
    module solidViewInches() {rotate_extrude() rot2();
    }
    
    module rotBack1() {
        rotate([-90,0,0])
        solidViewInches();
    }
    
    module inPosition() {translate([elevationOrigin.x, elevationOrigin.y, (2+1/2+1/8)/2]) rotBack1(); 
    }
    
    if (outType==1) {
        // don't need this because the tote bolt is not cut with waterjet.
        echo("do not need projection for waterjet");
    } else if (outType==2) {
        echo ("do not need view for 3D printing");
    } else if (outType==3)  {
        inPosition();
    } else {
        echo ("Invalid outType");
    }

}
