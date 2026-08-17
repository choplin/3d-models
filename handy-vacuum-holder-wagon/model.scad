// Holder for a Mitea Lab MyStick Neo (JK-1700R3), hung on the wall of a cargo wagon.
// Same socket as the desk-leg version -- it is included from
// ../handy-vacuum-holder/socket.scad, not restated -- on a different mount.
//
// The mount is a plain hook: two parallel plates with the wall's rail between them,
// tied by a bridge across the top. The bridge lands on the rail's top edge and carries
// the weight; the two plates take the tipping moment as a couple over their full
// height.
//
// Both plates run from the bed to the bridge, and the slot between them is open at the
// bottom and at both ends. That is what makes this printable in one piece and upright:
// hang a lip off a bridge instead and its underside starts in mid-air, needing a
// support tower the height of the whole part. Here nothing is unsupported except the
// bridge itself, a 5.8 mm span at the very top.
//
// The wall's top edge is a folded lip, thicker than the panel below it. The slot is
// sized to the lip, and a pad low on the outer plate takes it in to the panel further
// down -- so the hook is located at two heights 50 mm apart rather than pivoting on the
// lip alone. The lip cannot pass that pad without springing the plates open, which is
// exactly why the pad sits at the bottom: the plates are cantilevers rooted at the
// bridge, so that is where they give.
//
// Fitting is therefore a push, not a drop: the lip snaps past the pad and then rides up
// a clear slot to the bridge.
//
// Print orientation: upright, exactly as modelled, flat on the bed. No supports.
//
// One part.

include <../handy-vacuum-holder/socket.scad>

/* [Wagon wall] */
// The top edge is a folded lip: the panel runs on past it at wall_thickness, and an ear
// stands off one face only. Measured separately as 2 and 3.5, which sum to the 5.5 the
// whole edge was measured at -- two independent readings agreeing, so both are sound.
// Because the ear is on one face only, the OTHER face is flush all the way down, and
// only one plate needs a pad.
wall_thickness = 2;    // measured, approximate
ear_thickness  = 3.5;  // measured, approximate

// The ear stands off the side the socket is on, which is how this wagon is built, so
// the pad below goes on the outer plate. Mirroring it would mean moving the pad to the
// inner plate -- and the inner plate is the one that has to spring, so that variant
// would want its thicknesses swapping too.

rail_clearance = 0.3;  // snug at the lip, which is what locates the hook

// Measured. The lip is rounded rather than a constant 5.5 over this height. The slot is
// left straight rather than shaped to match: the profile is not known well enough to be
// worth chasing, and a straight slot bears on the lip's widest line.
rail_depth = 7;

/* [Pad] */
// A pad the thickness of the ear, on the plate facing it, taking the slot down to the
// panel's thickness below the lip. Without it the panel is loose in a slot 3.5 mm too
// wide and the hook nods about the lip -- 0.3 mm of slack over the lip's 7 mm is
// 2.5 deg, which throws the far end of a 320 mm vacuum about 15 mm sideways.
//
// The pad narrows the slot below what the lip can pass, so the lip has to spring the
// plates apart on the way in. That is only workable because the pad sits at the very
// bottom: the plates are cantilevers rooted at the bridge, so they are most compliant
// at their free end, and the lip meets the obstruction exactly there.
//
// With a 3 mm inner plate 50 mm wide and the pad ending at 12 mm, springing it the
// 3.2 mm needed takes about 22 N and works the root to some 14 MPa -- against PLA's
// ~50 MPa, a safety factor over three. Put the same pad at 55 mm instead and the
// required force runs to thousands of newtons: it is the position, not the pad, that
// decides whether this is possible.
pad_top     = 12;
pad_lead    = 4;  // ramp at the bottom, so the lip is guided into the squeeze
pad_chamfer = 2;  // and backed off at the top, so it releases cleanly

/* [Hook] */
hook_wall   = 4;   // the outer plate, which carries the socket
// The inner plate, thinner on purpose. It is the one that has to spring aside as the
// lip goes past the pad -- the outer plate is stiffened by the spine and will not flex
// -- and bending force goes as the cube of thickness, so 3 rather than 4 nearly halves
// what it takes to fit. In service it only resists the outward pull at the lip, which
// is a couple of newtons.
inner_wall  = 3;
hook_width  = 50;  // across the wall
arm_gap     = 3;   // clear space between the hook and the socket
spine_width = 24;

/* [Hidden] */
// (wall, clearance, eps and the socket dimensions come from socket.scad)
knit = 1;  // how far neighbouring solids reach into each other

// --- derived ---------------------------------------------------------------

rail_thickness = wall_thickness + ear_thickness;
slot           = rail_thickness + rail_clearance;
hook_height    = socket_h;          // plates run the socket's full height
bridge_z       = hook_height;

hook_x0        = -(slot + inner_wall);  // back face of the inner plate
socket_x       = hook_wall + arm_gap + socket_back;

// What the lip has to open the slot by on its way past the pad, and how far up the
// obstruction reaches. Both are echoed because together they decide whether the thing
// can be fitted by hand at all.
spring_open  = rail_thickness - (slot - ear_thickness);
cantilever   = bridge_z - pad_top;

echo(min_wall = min(wall, inner_wall));
echo(rail_thickness = rail_thickness, slot_width = slot, pad = ear_thickness);
echo(spring_open = spring_open, at_cantilever_length = cantilever);
echo(socket_height = socket_h, reach_from_wall = socket_x);
echo(tail_clears_bottom = tail_length > throat_height,
     body_clears_top    = dock_z + total_height > socket_h);

// --- hook ------------------------------------------------------------------

// Everything here overlaps its neighbour by `knit` rather than butting onto its face.
// Two solids that only meet on a plane are not a union -- CGAL is free to leave them as
// separate bodies, and then the part prints in pieces. The genus reported on export is
// the check: one body with one through-bore reads as 1, and anything less means
// something came apart.
module hook() {
    // The plates run past the bridge rather than stopping under it, so the two
    // interpenetrate. The slot's ceiling is still the bridge's underside at bridge_z.
    translate([0, -hook_width / 2, 0])
        cube([hook_wall, hook_width, bridge_z + hook_wall]);

    translate([hook_x0, -hook_width / 2, 0])
        cube([inner_wall, hook_width, bridge_z + hook_wall]);

    // bridge over the rail's top edge, tying the two together
    translate([hook_x0, -hook_width / 2, bridge_z])
        cube([hook_wall + inner_wall + slot, hook_width, hook_wall]);

    // The pad, low down where the plates give. Ramped at the bottom so the lip is led
    // into the squeeze, backed off at the top so it releases cleanly. Both ramps face
    // upwards as printed, so neither needs support.
    hull() {
        translate([-eps, -hook_width / 2, 0])
            cube([eps + knit, hook_width, eps]);
        translate([-ear_thickness, -hook_width / 2, pad_lead])
            cube([ear_thickness + knit, hook_width, pad_top - pad_lead - pad_chamfer]);
        translate([-eps, -hook_width / 2, pad_top - eps])
            cube([eps + knit, hook_width, eps]);
    }
}


// Starts at the plate's inner face, not its outer one, so the two interpenetrate.
module spine() {
    translate([0, -spine_width / 2, 0])
        cube([socket_x, spine_width, socket_h]);
}

module holder() {
    difference() {
        union() {
            hook();
            spine();
            translate([socket_x, 0, 0]) socket_shell();
        }
        translate([socket_x, 0, 0]) socket_void();
    }
}

module main() {
    holder();
}

main();
