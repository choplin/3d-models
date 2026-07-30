// Under-keyboard mount for a Focusrite Scarlett 4i4 4th gen, hung from one of
// the front-to-back top support arms of a Z-type keyboard stand (Donner, 60-85 cm).
//
// Orientation: the bar runs FRONT TO BACK, i.e. along this model's Y axis, which
// is also the unit's depth axis. So the unit's front panel faces the player,
// parallel to the bar. The keyboard lies across the two arms, above.
//
// How it mounts: the thickened band down the centre of the ceiling beds against
// the UNDERSIDE of the bar, and two straps (zip ties or hook-and-loop) pass up
// through the four slots and around the bar. Nothing sits on top of the bar
// except the strap, so the keyboard still rests on the bar and is lifted only by
// the strap thickness. A groove along the ceiling locates the bar sideways and
// takes a rubber strip - see the note on groove_depth.
//
// The unit slides in from the FRONT, tilted over the front lip, and is stopped by
// the rear stop. Front and rear are open so the front-panel jacks and the rear
// USB-C / line outs stay reachable. The top panel is NOT reachable once mounted -
// that is inherent to putting the unit under a keyboard.
//
// The ceiling is a full plate rather than a bar-width band: with the bar running
// along Y, the band alone would only reach the front lip and rear stop, so the
// shell has to hang off a plate that reaches the side walls. It is thin away from
// the band and windowed to keep the mass down.
//
// Print orientation: standing on the REAR face (the +Y face), i.e. rotate 90 deg
// about X in the slicer, or set orient_for_print = true to export it already
// rotated. The part is then a rectangular tube standing on a closed perimeter
// ring: every wall vertical, the load path inside the layers, good bed adhesion.
//
// That makes the build direction -Y, so each layer is one cross-section through
// the depth of the box. Every lightening window therefore has an end that CLOSES
// in the build direction, and a square-ended window would have to be bridged
// there. So all the windows have 45 degree ends (window_2d) and the floor window
// is split into three, keeping every closing edge self-supporting.
// No supports needed, and no span longer than 3 mm has to be bridged. Two things
// do come out unsupported, and a slicer will flag the second of them:
//   - the strap slots as they close, 3 mm across, 54 mm2 each;
//   - the front lip's inner face, 181 x 3 mm. It appears in one layer near the
//     top of the print, but it is anchored along its whole 181 mm lower edge to
//     the floor beneath it, so it is a 3 mm step, not a 181 mm bridge. Slicers
//     report it by extrusion length rather than by span, hence the warning.
// The lip is left with a vertical face on purpose. Chamfering it at 45 degrees
// would remove the warning and turn the stop into a ramp the unit can climb: a
// vertical 3 mm step needs the unit to be lifted before it can escape, while a
// 45 degree ramp lets a ~15 N forward pull walk it out, well under what
// unplugging a stiff jack applies.

/* [Audio interface] */
// Focusrite Scarlett 4i4 4th gen, off the unit with calipers. Width and height
// match Focusrite's published figures; the depth comes out 14 mm under their 129,
// which is consistent with the published number including front and rear
// protrusions that the chassis itself does not have.
device_width  = 180;  // measured
device_depth  = 115;  // measured
device_height = 59;   // measured
// total slack across each cavity dimension; larger than the profile's
// fit_clearance because this is a drop-in cradle, not a press fit
device_fit    = 1.2;

/* [Stand bar] */
bar_width     = 30;   // measured - the arm's horizontal width
bar_play       = 1.0; // slack in the locating groove
// Depth costs nothing in drop below the arm: the arm sits down inside the groove,
// so only the material UNDER the groove adds height. Made generous instead, which
// improves sideways location and resistance to tipping, and leaves room for the
// rubber strip that resists fore-and-aft creep. See the note at the foot of the
// file for why that strip matters.
groove_depth  = 5.0;

// The arm's underside has a hook socket with a ~1 mm raised rim round it. Rather
// than positioning the mount to dodge it, the groove floor carries a relief
// channel down its centre, so the arm beds on two shoulders either side and any
// such feature has somewhere to go wherever it happens to sit along the arm.
relief_width  = 14;
relief_depth  = 1.5;
band_offset_x = 0;    // shift the band if the bar is not centred under the unit

/* [Straps] */
// Sized well over the 3 x 1 mm ties in hand: the slot drives no outer dimension,
// so the slack is free, and it leaves room to double up ties or move to a
// hook-and-loop strap without reprinting.
strap_slot_width     = 14;  // along the bar
strap_slot_thickness = 3;
strap_spacing_y      = 90;  // centre-to-centre of the two strap loops, along the bar
strap_wall           = 5;   // material each side of a slot; it carries the load

/* [Shell] */
side_wall         = 4;
floor_thickness   = 3.2;
lip_wall          = 2.8;
ceiling_thickness = 9;    // the band under the groove
ceiling_skin      = 3.2;  // the rest of the ceiling plate
device_clearance  = 4.5;  // headroom, enough to tilt the unit in over the front lip
front_lip_height  = 3;
// The lowest thing on the rear panel sits about 10 mm above the underside of the
// feet, so the stop has to clear it: it only has to arrest the unit as it slides
// back, and nothing loads it.
rear_stop_height  = 7;

/* [Lightening windows] */
floor_rim     = 20;
side_rim      = 12;
ceiling_rim   = 12;
// The floor window is split so each piece is narrow enough for its 45 degree end
// to close within the window's own length. One wide window cannot: closing 149 mm
// at 45 degrees would need 75 mm of run and only 96 mm of length exists.
floor_windows = 3;
floor_rib     = 12;
// Multiplier on the 45 degree end taper. 1.0 gives exactly 45 degrees, the usual
// self-supporting limit; raise it if the first print shows the ends drooping.
window_taper  = 1.0;

/* [Output] */
orient_for_print = false;

/* [Hidden] */
$fn = 48;
eps = 0.01;

// --- derived -----------------------------------------------------------------
cav_x   = device_width + device_fit;
cav_y   = device_depth + device_fit;
outer_x = cav_x + 2 * side_wall;
outer_y = cav_y + 2 * lip_wall;

// Z datum: 0 is the top face of the ceiling, which beds against the bar.
ceiling_bottom_z = -ceiling_thickness;
device_top_z     = ceiling_bottom_z - device_clearance;
device_bottom_z  = device_top_z - device_height;
floor_top_z      = device_bottom_z;
floor_bottom_z   = floor_top_z - floor_thickness;

groove_x   = bar_width + bar_play;
slot_mid_x = groove_x / 2 + strap_wall + strap_slot_thickness / 2;
band_x     = groove_x + 2 * (strap_wall + strap_slot_thickness + strap_wall);

echo(min_wall = min(side_wall, floor_thickness, lip_wall, strap_wall, ceiling_skin,
                    ceiling_thickness - groove_depth - relief_depth));
echo(overall = [outer_x, outer_y, -floor_bottom_z]);
// What actually matters on this stand: how far the mount reaches below the arm's
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
    span = outer_x - 2 * floor_rim;
    w    = (span - (floor_windows - 1) * floor_rib) / floor_windows;
    l    = outer_y - 2 * floor_rim;
    difference() {
        translate([-outer_x / 2, -outer_y / 2, floor_bottom_z])
            cube([outer_x, outer_y, floor_thickness]);
        for (i = [0 : floor_windows - 1])
            translate([-span / 2 + w / 2 + i * (w + floor_rib), 0,
                       floor_bottom_z - eps])
                linear_extrude(floor_thickness + 2 * eps) window_2d(w, l);
    }
}

module side_wall_plate() {
    z_top = ceiling_bottom_z - side_rim;
    z_bot = floor_bottom_z + side_rim;
    difference() {
        translate([-side_wall / 2, -outer_y / 2, floor_bottom_z])
            cube([side_wall, outer_y, -floor_bottom_z]);
        translate([-side_wall / 2 - eps, 0, (z_top + z_bot) / 2])
            rotate([0, 90, 0])
                linear_extrude(side_wall + 2 * eps)
                    window_2d(z_top - z_bot, outer_y - 2 * side_rim);
    }
}

module side_walls() {
    for (s = [-1, 1])
        translate([s * (cav_x / 2 + side_wall / 2), 0, 0])
            side_wall_plate();
}

// Thin plate over the whole footprint, thickened to a band down the centre where
// the bar sits. One window each side of the band; the band itself stays solid
// because the load runs from the straps out to the side walls through it.
module ceiling() {
    // One window between each side of the band and the outer rim, sized per side
    // so band_offset_x stays usable.
    left  = [-outer_x / 2 + ceiling_rim,
             band_offset_x - band_x / 2 - ceiling_rim];
    right = [band_offset_x + band_x / 2 + ceiling_rim,
             outer_x / 2 - ceiling_rim];
    l = outer_y - 2 * ceiling_rim;
    union() {
        difference() {
            translate([-outer_x / 2, -outer_y / 2, -ceiling_skin])
                cube([outer_x, outer_y, ceiling_skin]);
            for (win = [left, right])
                translate([(win[0] + win[1]) / 2, 0, -ceiling_skin - eps])
                    linear_extrude(ceiling_skin + 2 * eps)
                        window_2d(win[1] - win[0], l);
        }
        translate([band_offset_x - band_x / 2, -outer_y / 2, ceiling_bottom_z])
            cube([band_x, outer_y, ceiling_thickness]);
    }
}

module front_lip() {
    translate([-outer_x / 2, -outer_y / 2, floor_bottom_z])
        cube([outer_x, lip_wall, floor_thickness + front_lip_height]);
}

module rear_stop() {
    translate([-outer_x / 2, cav_y / 2, floor_bottom_z])
        cube([outer_x, lip_wall, floor_thickness + rear_stop_height]);
}

// The recess the bar sits in, running the full length of the part along Y.
module bar_groove() {
    translate([band_offset_x - groove_x / 2, -outer_y / 2 - eps, -groove_depth])
        cube([groove_x, outer_y + 2 * eps, groove_depth + device_clearance]);
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
            ceiling();
            front_lip();
            rear_stop();
        }
        bar_groove();
        underside_relief();
        strap_slots();
    }
}

// The internal Z datum is the bar contact plane, so body() is built entirely at
// negative Z. Both branches lift it onto Z = 0 — otherwise it sits underneath
// OpenSCAD's build platform in the GUI and renders as an empty view.
module main() {
    if (orient_for_print)
        translate([0, 0, outer_y / 2]) rotate([-90, 0, 0]) body();
    else
        translate([0, 0, -floor_bottom_z]) body();
}

main();

// Note on fore-and-aft holding force. Plugging and unplugging front-panel cables
// pushes and pulls along Y, which is now parallel to the bar, so the groove walls
// cannot bear against anything - only strap friction resists it. Bare nylon on a
// painted steel tube gives roughly 0.25 friction coefficient, so two ties at
// ~300 N total give ~75 N against a ~50 N pull: too close. Lay a 1.5 mm strip of
// rubber (a scrap of shelf liner or an old inner tube) in the groove and the
// coefficient goes to ~0.8, i.e. ~240 N. Doubling up to four ties helps too.
// The failure mode is gradual creep along the bar, not breakage - visible and
// re-tightenable rather than sudden.
