// Filament spool crossbar holder for Nite's Palette & Filament frame
// 4 of these are used
// Based on Mitsui 2020 series extrusion
// (c) 2019 Nitehawk

// Parameters
// Block width
blockw = 20; // 2020 / 2040 rail - single slot
// Block Height
blockl = 40; // Doesn't have to be this long, but this gives a bit of 

// Filament holder rod diameter
rodd = 7;   // (7mm diameter for 608ZZ (8x22x7) bearings)
// Spacing between rods
rodspc = .5;

// Mounting hole - M5 default
// Length of screw
mountscrewlen = 10; // This adjusts how thick the bottom of the mount is
// Diameter of screw
mountscrewd = 5;
// diameter of screw cap
mountcapd = 8.7;
// height of screw cap
mountcaph = 5;

// Extrusion info - Mitsui 
// Depth of extrusion channel (Mitsui 2020)
escrewlen = 6; // max length screw can go into the channel
// Width of extrusion slot (Mitsui 2020)
eslotw = 6; // Width of slot - We'll add a small positioning aid


// Include some MCAD stuff
include <MCAD/boxes.scad>;

// Figure out our total height
blockh = mountscrewlen - escrewlen + mountcaph + (rodd/2);
blockbaset = mountscrewlen - escrewlen + mountcaph;

// Positioning aid stuff - Max 2.5 mm each
ph = min(escrewlen, 1);
// Screw uses mountcapd + 2
pl = min((blockl-mountcapd-2), 5)/2;
assert(pl >= .25);

// How many slots will fit
nslots = floor(blockl / (rodd + rodspc));
slotaoff=(blockl-(nslots*(rodd+rodspc)))/2;
echo("Slots:", nslots, slotaoff, nslots*(rodd+rodspc));

// Smooth curves
$fn=30;

// Buildup the object
difference() {
    union () {
        // Starting block
        roundedBox([blockl, blockw, blockh],1, true);
        // Positioning aids
        translate([-(blockl/2), -(eslotw/2), -(blockh/2)-ph])
            cube([pl, eslotw, ph]);
        translate([+(blockl/2)-pl, -(eslotw/2), -(blockh/2)-ph])
            cube([pl, eslotw, ph]);
    }
    // Screw hole - Center of block
    cylinder(d=mountscrewd, h=blockh, center=true);
    translate([0,0,blockbaset-mountcaph])
        cylinder(d=mountcapd, h=blockh, center=true);
    
    // Line of positions for the rod
    slotbot=-blockh/2 + blockbaset + rodd/2;
    echo(blockh, slotbot);
    for (a = [1:nslots]) {
        pos = -(blockl/2) + slotaoff + (a-1)*(rodd+rodspc)+rodd/2;
        translate([pos,0,slotbot]) rotate([90,0,0]) 
            cylinder(d=rodd, h=blockw, center=true);
    }
}