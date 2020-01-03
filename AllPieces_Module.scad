source="Assembly.dxf";
module allPieces() {
    // Generate an in-position object for each piece in different colours
    include <ThroatHolder_Module.scad>;
    color("Plum") throatHolder(3); 
    include <Throat_Module.scad>;
    color("Cyan") throat(3);  
    include <Frog_Module.scad>;
    color("Plum") frog(3);
    include <Blade_Module.scad>;
    color("Cyan") blade(3); 
    include <AdjustHolder_Module.scad>;
    color("Plum") adjustHolder(3);
    include <SoleFront_Module.scad>;
    color("PowderBlue") soleFront(3);
    include <SoleRear_Module.scad>;
    color("PowderBlue") soleRear(3);
    include <Side_Module.scad>;
    color("Pink") side(3);
    include <AdjustScrew_Module.scad>;
    color("Lime") adjustScrew(3);
    include <Tote_Module.scad>;
    color("Lime") tote(3);
    include <Knob_Module.scad>;
    color("Lime") knob(3); 
}
allPieces();