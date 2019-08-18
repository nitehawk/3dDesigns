// OpenSCAD design by Nitehawk
// Twitter: @nite97m
// Github: @Nitehawk
// Thingiverse: @Nitehawk
//
// Design based on: https://www.thingiverse.com/thing:2788335
// and:  https://www.thingiverse.com/thing:2766979

// We want our holes to be nice and smooth
$fn = 30;

// Which mount should we build
mountc615=true;
mounttripod=false;

// Define some sizes  --- Note:  changing these parameters is probably not safe
at=12;   // Arm thickness
aw=22;   // Arm width
alen=120; // Lenth of arm under build bed - before mount segment
clen=45; // Length of 45 degree segment

// Camera mount offset towards bed center (default is ~60 degree angle)
offheight=120;
offcenter=70;

// Horizontal/vertical offset for the corner segment
// a^2 + b^2 = clen^2 - a==b
choff = sqrt((clen*clen)/2);


union() {
    // First section connects to the corner of the build support platform
    translate([0,alen,0]) rotate([10,0,0]) difference() {
        // We're doing some math with these - make them easy to change
        ml=56;
        mlopen=29;
        lhsize=4.3;
        uhsize=9;
        hdist=13.8;
        cube([aw,ml,at]);
        translate([0,ml-mlopen,at/3])
            cube([aw,mlopen,at/3]);
        translate([aw/2,ml-hdist,0])
            cylinder(h=at, d=lhsize);
        translate([aw/2,ml-hdist,at/3])
            cylinder(h=2*at/3, d=uhsize);
    }
    // Main extension to get from the corner of the bed to the front
    cube  ([aw,alen,at]);
    // Corner section before vertical
    translate  ([aw,0,0])
        rotate ([45,0,180])
        cube   ([aw,clen,at]);
    // Vertical standoff - Cheat to smooth
    translate  ([0,-choff, choff])
        cube   ([aw,at,20]);
    // Vertical support
    translate ([0,-choff, choff+20])
        ctrbar();
    // Mount -- This positioning doesn't quite work for anything other than default centering angle
    translate  ([offcenter-3,-choff,choff+offheight+9])
        mount();
}

module ctrbar() {
    rot=atan(offheight/offcenter);
    len=sqrt(offheight*offheight + offcenter*offcenter);
    rotate([0,90-rot,0]) cube([aw,at,len]);
}

module mount() {
    base=20;
    // C615 Mount
    if (mountc615) {
        union() {
            cube([aw, at, base]);
            translate([-(33.5-aw)/2,0,base]) difference() {
                cube([33.5,at+10,6]);
                translate([(33.5-22)/2,at+1,0]) cube([22,9,7]);
                #translate([0,at+9,3]) rotate([0,90,0]) cylinder(h=33.5, d=2.35);
            }
        }
    }
    // Tripod (1/4"x20) mount
    if (mounttripod) {
    }
}