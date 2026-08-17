// Viewable reference for the Mitea Lab MyStick Neo (JK-1700R3): the same solid that
// vacuum.scad defines, drawn in colour so the four sections can be told apart and
// argued about. Not a printable part -- it is the vacuum itself.
//
// The dimensions live in vacuum.scad, not here. Edit them there; anything built around
// the vacuum reads the same file, so a change lands everywhere at once.
//
// Lengths along the axis for the tail and body are arbitrary. Only the cross-sections
// and the tail's position relative to the body axis mean anything.

include <vacuum.scad>

/* [Display] */
tail_colour  = "SteelBlue";
step_colour  = "IndianRed";
slope_colour = "MediumSeaGreen";
body_colour  = "Goldenrod";

// Not a printed part; nothing here is a wall. Echoed so the geometry checks have a
// value to read rather than failing on a missing one.
echo(min_wall = min(tail_flats, body_diameter));
echo(arc_radius = arc_radius, tail_offset = tail_offset, tail_proud = tail_proud);
echo(ring_continued = ring_continued, vs_step_diameter = step_diameter);
echo(step_span = step_span, vs_measured = 53.9);

module main() {
    color(tail_colour)
        linear_extrude(total_height) tail_profile();

    color(step_colour)
        translate([0, 0, step_z])
            linear_extrude(step_height) step_profile();

    color(slope_colour)
        for (i = [0 : ring_count - 1])
            translate([0, 0, slope_z + i * ring_height])
                cylinder(h = ring_height,
                         d = body_diameter - (ring_count - i) * ring_step);

    color(body_colour)
        translate([0, 0, body_z])
            cylinder(h = body_length, d = body_diameter);
}

main();
