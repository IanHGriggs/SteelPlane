module adjustScrew(outType){
    source="Assembly.dxf";
    objectName="AdjustScrew";
    $fn=64;
  
    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    elevationTopOriginLayer=str(objectName, "_ElevationTopOrigin");
    
    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
   
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);
    elevationTopOrigin = dxf_cross (file=source, layer=elevationTopOriginLayer, origin=[0,0], scale=1);
    xLength = elevationTopOrigin.x - elevationOrigin.x;
    yLength = elevationTopOrigin.y - elevationOrigin.y;
    length = sqrt(pow(xLength,2) + pow(yLength,2));

    module elevationTranslated () {
        translate([-elevationOrigin.x, -elevationOrigin.y,0]) elevation();
    }
    
    module rot1() {rotate([0,0,40]) elevationTranslated();
    }
    // trim a bit so the 2D shape lies completely on one side of the X axis.
    module trimBit() { square(size=[.001, 4], center=false);
    }
    
    module rot2() { difference() {rot1(); trimBit();};
    }
    
    module solidViewInches() {rotate_extrude() rot2();
    }
    
    module rotBack1() {
        rotate([-90,0,0])
        solidViewInches();
    }
    
    module rotBack2() {rotate([0,0, -40]) rotBack1();
    }
    
    module inPosition() {translate([elevationOrigin.x, elevationOrigin.y, (2+1/2+1/8)/2]) rotBack2(); 
    }
    
    module solidViewMM () {scale (v=[25.4, 25.4, 25.4]) solidViewInches();
    }
    
    if (outType==1) {
        // don't need this because the adjust screw is not cut with waterjet.
        echo("Unneeded projection for waterjet");
    } else if (outType==2) {
        // for 3D printing, turn upside down so the fattest end is on the bottom.
        translate([0,0,length*25.4]) rotate([180, 0, 0]) solidViewMM();
    } else if (outType==3)  {
        inPosition();
    } else {
        echo ("Invalid outType");
    }

}

