module toteBolt(outType){
    source="Assembly.dxf";
    objectName="ToteBolt";
    $fn=64;
  
    elevationLayer=str(objectName,"_Elevation");
    elevationOriginLayer=str(objectName, "_ElevationOrigin");
    elevationTopOriginLayer=str(objectName, "_ElevationTopOrigin");
    
    module elevation () {import(source, layer=elevationLayer, origin=[0,0], scale=1) ;
    }
   
    elevationOrigin = dxf_cross (file=source, layer=elevationOriginLayer, origin=[0,0], scale=1);

    module elevationTranslated () {
        translate([-elevationOrigin.x, -elevationOrigin.y,0]) elevation();
    }
    
    // rotate 2D shape around the Z axis so centre of bolt is on the Y axis.f
    module rot1() {rotate([0,0,-rotAngle]) elevationTranslated();
    }
    // trim a bit so the 2D shape lies completely on one side of the X axis.
    // The .01 dimension is what seems to work for the "render" tool.
    module trimBit() { square(size=[.01, 4], center=false);
    }
    
    module rot2() { difference() {rot1(); trimBit();};
    }
    
    module solidViewInchesWithCore() {rotate_extrude(convexity=10) rot2();
    }
    
    // Fill the core left by the trimming, which is centered on the Z axis.
    elevationTopOrigin = dxf_cross (file=source, layer="ToteBolt_ElevationTopOrigin", origin=[0,0], scale=1);
    vect = elevationTopOrigin - elevationOrigin;
    height=norm(vect);

    module circ () { cylinder(h=height, d1=1/8, d2=1/8, center=false);
    }
    
    module solidViewInches() { union() {solidViewInchesWithCore(); circ();}
    }
    
    module rotBack1() {
        rotate([-90,0,0])
        solidViewInches();
    }
    rotAngle = 20;
    module rotBack2() {rotate([0,0, rotAngle]) rotBack1();
    }
    
    module inPosition() {translate([elevationOrigin.x, elevationOrigin.y, (2+1/2+1/8)/2]) rotBack2(); 
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
  