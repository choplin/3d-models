// Under-keyboard parts tray, hung from one of the front-to-back top support arms
// of a Z-type keyboard stand (Donner, 60-85 cm). Same mounting scheme as
// scarlett-4i4-under-keyboard-mount: a grooved band down the centre of the
// ceiling beds against the UNDERSIDE of the arm, and two straps (zip ties or
// hook-and-loop) pass up through four slots and around the arm.
//
// Orientation: the arm runs FRONT TO BACK, i.e. along this model's Y axis. The
// keyboard lies across the two arms, above. The tray's open side faces the
// player, along -Y.
//
// What it holds: a tuner, picks, a string winder, a wireless receiver. Long
// things lie ACROSS the tray, along X, where there is tray_width to use; the
// depth along the arm is the direction you have to reach into, so it is kept
// short enough to see into.
//
// How open it is. The FRONT is fully open - no lip, no stop. The REAR is open
// above rear_wall_height. The SIDE WALLS are windowed. Only the floor and the
// ceiling are unbroken. Nothing therefore retains a loose item against being
// knocked out of the front; that is a deliberate choice for reach and for looks,
// not an oversight. The side windows stop short of the floor, so there is a
// side_window_curb-high kerb along each side; echo() reports it.
//
// The band down the centre of the ceiling hangs lower than the rest of it, so the
// clear height is not uniform: tray_height under the ceiling skin, less
// (ceiling_thickness - ceiling_skin) under the band itself. Tall items go either
// side of the centre line. echo() reports both numbers.
//
// The ceiling is a full plate rather than an arm-width band, for the same reason
// as in the 4i4 mount: with the arm running along Y, a band alone would reach
// nothing but the rear wall, so the shell has to hang off a plate that reaches
// the side walls. It is thin away from the band and windowed to keep the mass
// down.
//
// The load path is the closed tube formed by ceiling, side walls and floor, which
// is intact at every Y. The rear wall carries nothing, which is why it can be cut
// down to half height without weakening anything.
//
// Print orientation: standing on the REAR face (the +Y face), i.e. rotate 90 deg
// about X in the slicer, or set orient_for_print = true to export it already
// rotated. Every wall is then vertical, with the load path inside the layers, and
// the first layer is the closed ring of floor + side walls + ceiling with the
// rear wall filling most of it.
//
// That makes the build direction -Y, so each layer is one cross-section through
// the depth of the tray, and any surface FACING THE REAR is a downward-facing
// surface in the print. With the front lip gone, the part no longer closes at all
// in the build direction - it simply ends - so the only such surfaces left are
// the window ends, and those taper at 45 degrees (window_2d) so they close one
// extrusion at a time. Nothing is bridged.
// The strap slots still close unsupported as they end, 3 mm across, 42 mm2 each -
// the same detail that printed acceptably on the 4i4 mount.
// No supports needed anywhere.

/* [Tray] */
// Inside dimensions. Width runs across the arm, depth along it, height is the
// clear space under the ceiling skin.
// Nothing here is a fit dimension, so these are preferences rather than
// measurements - but they are also what the part costs: the floor and the
// ceiling are both full-footprint plates, so width x depth sets the mass almost
// linearly. Roughly 1 g of PLA per 8 cm2 of footprint, before the walls.
tray_width  = 220;  // placeholder
tray_depth  = 150;  // placeholder
tray_height = 62;   // placeholder

/* [Stand bar] */
// All measured off the same stand as the 4i4 mount.
bar_width     = 30;   // measured - the arm's horizontal width
bar_play      = 1.0;  // slack in the locating groove
// Depth costs nothing in drop below the arm: the arm sits down inside the groove,
// so only the material UNDER the groove adds height. Made generous instead, which
// improves sideways location and resistance to tipping, and leaves room for the
// rubber strip that resists fore-and-aft creep. See the note at the foot of the
// file.
groove_depth  = 5.0;
// The arm's underside has a hook socket with a ~1 mm raised rim round it. The
// groove floor carries a relief channel down its centre, so the arm beds on two
// shoulders either side and the rim has somewhere to go wherever it sits.
relief_width  = 14;
relief_depth  = 1.5;
band_offset_x = 0;    // shift the band if the arm is not centred under the tray

/* [Straps] */
strap_slot_width     = 14;  // along the arm
strap_slot_thickness = 3;
// Centre-to-centre of the two strap loops, along the arm. Wider is stiffer
// against the tray rocking fore and aft, so it is set as wide as tray_depth
// allows: the slots have to stay clear of the front and rear faces.
strap_spacing_y      = 110;
strap_wall           = 5;   // material each side of a slot; it carries the load

/* [Shell] */
// Thinner than the 4i4 mount's walls: this shell carries a few hundred grams of
// oddments rather than a 1 kg instrument.
side_wall         = 2.4;
rear_wall         = 2.4;
floor_thickness   = 2.4;
ceiling_thickness = 9;    // the band under the groove
ceiling_skin      = 3.2;  // the rest of the ceiling plate
// How much of the back is open, as a fraction of the inside height. 0 gives a
// full-height back, 1 removes the rear wall entirely - which is structurally
// fine but takes away the only thing stopping something being pushed out the
// back, and takes away most of the first layer's area with it.
rear_open_fraction = 0.5;

/* [Lightening windows] */
// The floor and the ceiling stay unbroken - a hole in either is a hole a pick
// goes through. The side walls are windowed, but the window stops side_rim short
// of the outside faces, which leaves a kerb standing above the floor.
side_rim     = 12;
ceiling_rim  = 12;
// Multiplier on the 45 degree end taper. 1.0 gives exactly 45 degrees, the usual
// self-supporting limit; raise it if a first print shows the ends drooping.
window_taper = 1.0;

/* [Output] */
orient_for_print = false;

/* [Hidden] */
$fn = 48;
eps = 0.01;

// --- derived -----------------------------------------------------------------
outer_x = tray_width + 2 * side_wall;
outer_y = tray_depth + rear_wall;

// Z datum: 0 is the top face of the ceiling, which beds against the arm.
ceiling_bottom_z = -ceiling_thickness;   // underside of the band
skin_bottom_z    = -ceiling_skin;        // underside of the plate away from the band
floor_top_z      = skin_bottom_z - tray_height;
floor_bottom_z   = floor_top_z - floor_thickness;

groove_x   = bar_width + bar_play;
slot_mid_x = groove_x / 2 + strap_wall + strap_slot_thickness / 2;
band_x     = groove_x + 2 * (strap_wall + strap_slot_thickness + strap_wall);

rear_in_y        = outer_y / 2 - rear_wall;   // inside face of the rear wall
rear_wall_height = tray_height * (1 - rear_open_fraction);
rear_wall_top_z  = floor_top_z + rear_wall_height;

// Side window extents. The top is set from the ceiling SKIN, not the band: the
// side walls stand where the ceiling is skin only.
side_win_top_z = skin_bottom_z - side_rim;
side_win_bot_z = floor_bottom_z + side_rim;
// How high the unbroken part of the side wall stands above the floor's top face.
side_window_curb = side_win_bot_z - floor_top_z;

// The slots run through the band, which spans the full depth, so nothing stops
// them opening out of the front or rear face except this.
assert(strap_spacing_y / 2 + strap_slot_width / 2 + strap_wall <= outer_y / 2,
       "strap slots reach the end faces - narrow strap_spacing_y or deepen the tray");
assert(side_win_bot_z < side_win_top_z,
       "side_rim leaves no side window - lower it or make the tray taller");

echo(min_wall = min(side_wall, rear_wall, floor_thickness, strap_wall,
                    ceiling_skin, ceiling_thickness - groove_depth - relief_depth));
echo(overall = [outer_x, outer_y, -floor_bottom_z]);
echo(clear_height_under_skin = tray_height,
     clear_height_under_band = tray_height - (ceiling_thickness - ceiling_skin));
echo(floor_area = [tray_width, tray_depth]);
echo(rear_wall_height = rear_wall_height, side_window_curb = side_window_curb);
// What actually matters on this stand: how far the tray reaches below the arm's
// underside, since the angled upright closes in as you go down.
echo(drop_below_arm = -floor_bottom_z - groove_depth);

// Window outline with 45 degree ends along Y. w is the width across the plate,
// l the length along Y. Because Y is the build direction, those ends close one
// layer-width at a time instead of needing a bridge.
module window_2d(w, l) {
    h   = w / 2;
    run = h * window_taper;
    assert(l > 2 * run,
           "window too short along Y for its taper - narrow it, split it, or lower window_taper");
    polygon([[-h, -(l / 2 - run)], [0, -l / 2], [h, -(l / 2 - run)],
             [h,    l / 2 - run],  [0,  l / 2], [-h,   l / 2 - run]]);
}

module floor_plate() {
    translate([-outer_x / 2, -outer_y / 2, floor_bottom_z])
        cube([outer_x, outer_y, floor_thickness]);
}

module side_wall_plate() {
    difference() {
        translate([-side_wall / 2, -outer_y / 2, floor_bottom_z])
            cube([side_wall, outer_y, -floor_bottom_z]);
        translate([-side_wall / 2 - eps, 0, (side_win_top_z + side_win_bot_z) / 2])
            rotate([0, 90, 0])
                linear_extrude(side_wall + 2 * eps)
                    window_2d(side_win_top_z - side_win_bot_z,
                              outer_y - 2 * side_rim);
    }
}

module side_walls() {
    for (s = [-1, 1])
        translate([s * (tray_width + side_wall) / 2, 0, 0])
            side_wall_plate();
}

// Cut down to rear_wall_height so the back is open above it. It carries no load -
// the ceiling/sides/floor tube does that - so its height is free to choose.
module rear_wall_plate() {
    translate([-outer_x / 2, rear_in_y, floor_bottom_z])
        cube([outer_x, rear_wall, rear_wall_top_z - floor_bottom_z]);
}

// Thin plate over the whole footprint, thickened to a band down the centre where
// the arm sits. One window each side of the band; the band itself stays solid
// because the load runs from the straps out to the side walls through it.
module ceiling() {
    left  = [-outer_x / 2 + ceiling_rim,
             band_offset_x - band_x / 2 - ceiling_rim];
    right = [band_offset_x + band_x / 2 + ceiling_rim,
             outer_x / 2 - ceiling_rim];
    l = outer_y - 2 * ceiling_rim;
    union() {
        difference() {
            translate([-outer_x / 2, -outer_y / 2, skin_bottom_z])
                cube([outer_x, outer_y, ceiling_skin]);
            for (win = [left, right])
                translate([(win[0] + win[1]) / 2, 0, skin_bottom_z - eps])
                    linear_extrude(ceiling_skin + 2 * eps)
                        window_2d(win[1] - win[0], l);
        }
        translate([band_offset_x - band_x / 2, -outer_y / 2, ceiling_bottom_z])
            cube([band_x, outer_y, ceiling_thickness]);
    }
}

// The recess the arm sits in, running the full length of the part along Y.
module bar_groove() {
    translate([band_offset_x - groove_x / 2, -outer_y / 2 - eps, -groove_depth])
        cube([groove_x, outer_y + 2 * eps, groove_depth + ceiling_thickness]);
}

// Relief down the centre of the groove floor, clearing the hook socket's rim.
module underside_relief() {
    translate([band_offset_x - relief_width / 2, -outer_y / 2 - eps,
               -(groove_depth + relief_depth)])
        cube([relief_width, outer_y + 2 * eps, relief_depth + eps]);
}

module strap_slots() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([band_offset_x + sx * slot_mid_x - strap_slot_thickness / 2,
                   sy * strap_spacing_y / 2 - strap_slot_width / 2,
                   ceiling_bottom_z - eps])
            cube([strap_slot_thickness, strap_slot_width,
                  ceiling_thickness + 2 * eps]);
}

module body() {
    difference() {
        union() {
            floor_plate();
            side_walls();
            rear_wall_plate();
            ceiling();
        }
        bar_groove();
        underside_relief();
        strap_slots();
    }
}

// The internal Z datum is the arm contact plane, so body() is built entirely at
// negative Z. Both branches lift it onto Z = 0 - otherwise it sits underneath
// OpenSCAD's build platform in the GUI and renders as an empty view.
module main() {
    if (orient_for_print)
        translate([0, 0, outer_y / 2]) rotate([-90, 0, 0]) body();
    else
        translate([0, 0, -floor_bottom_z]) body();
}

main();

// Note on fore-and-aft holding force, carried over from the 4i4 mount. The strap
// is all that resists sliding ALONG the arm, because the groove walls are
// parallel to it. Bare nylon on painted steel gives roughly 0.25 friction
// coefficient; a 1.5 mm strip of rubber in the groove (shelf liner, inner tube)
// takes it to ~0.8. The tray is far lighter than the interface and nothing pulls
// on it, so the margin here is not tight - but the strip costs nothing and stops
// the tray creeping along the arm when it is knocked.
