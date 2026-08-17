// The Mitea Lab MyStick Neo (JK-1700R3) as a solid, from measurement. Shared: this file
// defines the vacuum, and anything built around it includes this rather than restating
// its dimensions. A holder derived by subtracting vacuum_solid() cannot disagree with
// the vacuum about its own shape.
//
// No geometry is emitted here -- only parameters and modules -- so this is safe to
// `include <>`. See model.scad in this directory for the viewable, coloured version.
//
// Going up from the tail end:
//   tail   a rectangle with its two ends bulged into arcs, flatter than semicircles.
//          Off-axis, and it runs the whole length rather than stopping at the body, so
//          where it stands proud of the body circle it shows as a full-length ridge.
//   step   half a disc concentric with the slope, merging into the tail on the far side
//   slope  four louvred rings, each narrower than the body
//   body   a circle
//
// The cross-section never shrinks going up. That is what makes the vacuum droppable
// into a socket cut to this exact profile: on the way down, everything that passes a
// given height is narrower than what finally rests there.

/* [Body -- the round part] */
body_diameter = 63.4;  // measured
body_length   = 100;   // arbitrary -- only has to outrun any holder built around this

/* [Slope -- louvred rings under the body, concentric with it] */
ring_count    = 4;     // measured -- every ring is narrower than the body
ring_height   = 2.5;   // measured -- axial pitch of one ring
ring_step     = 5;     // measured -- diameter lost per ring, going down

/* [Step section -- between the tail and the slope] */
// Half its outline is a semicircle concentric with the slope, carrying the staircase
// one size further down; the other half merges into the tail. Its diameter matching the
// tail's short axis is what lets the two halves meet along a straight line.
step_diameter = 37.3;  // = tail_flats
step_height   = 15;    // measured

/* [Tail] */
tail_across   = 43.0;  // measured -- long axis, tip of one arc to the other
tail_flats    = 37.3;  // measured -- short axis, between the two straight sides
tail_length   = 100;   // arbitrary -- exposed length below the step, hangs free

// How long the straight sides run before the end arcs start. This one number fixes how
// flat the arcs are, and everything else about the tail follows from it. 5.7 would make
// the ends exact semicircles, which they are not.
// On the real product the straight blends into the arc rather than meeting it at a
// corner, so this is the softest number in the model. Measured at roughly 18; a printed
// socket built on 18 left a visible gap against the real tail, so it is a little
// shorter than that. 16 is a first correction, not a measurement -- slide it in live
// preview against the part if the gap is still there.
tail_straight = 16;

// Measured across the short axis: the tail's outline crosses the body circle where the
// tail is this wide. Given the arc shape above, this pins where the tail sits, so the
// offset below is solved for rather than guessed.
tail_crossing = 30;

/* [Hidden] */
$fn = 128;

// --- derived ---------------------------------------------------------------

arc_bulge  = (tail_across - tail_straight) / 2;
arc_radius = (pow(tail_flats / 2, 2) + pow(arc_bulge, 2)) / (2 * arc_bulge);

cross_y    = tail_crossing / 2;
tail_x_at  = tail_straight / 2 + sqrt(pow(arc_radius, 2) - pow(cross_y, 2))
                               - (arc_radius - arc_bulge);
body_x_at   = sqrt(pow(body_diameter / 2, 2) - pow(cross_y, 2));
tail_offset = body_x_at - tail_x_at;

// Positive means the tail's far end stands proud of the body circle.
tail_proud  = tail_offset + tail_across / 2 - body_diameter / 2;

step_z       = tail_length;
slope_z      = step_z + step_height;
slope_height = ring_count * ring_height;
body_z       = slope_z + slope_height;
total_height = body_z + body_length;

// Two independent checks on the measurements. Both land within about a millimetre,
// which is the agreed tolerance -- see the notes in this directory.
ring_continued = body_diameter - (ring_count + 1) * ring_step;  // vs step_diameter
step_span      = step_diameter / 2 + tail_offset + tail_across / 2;  // vs 53.9 measured

// --- cross-sections --------------------------------------------------------

// A rectangle whose two ends bulge out into circular arcs of the given depth.
module arc_ended_rect(len, wid, straight) {
    bulge = (len - straight) / 2;
    r     = (pow(wid / 2, 2) + pow(bulge, 2)) / (2 * bulge);

    union() {
        square([straight, wid], center = true);
        for (s = [0, 1])
            mirror([s, 0])
                intersection() {
                    translate([straight / 2 - (r - bulge), 0]) circle(r = r);
                    translate([straight / 2 + len, 0])
                        square([2 * len, 2 * wid], center = true);
                }
    }
}

// Every profile takes a growth `g`: 0 for the vacuum itself, a clearance for the void a
// holder cuts, clearance + wall for that holder's outer skin.
module tail_profile(g = 0) {
    translate([tail_offset, 0])
        offset(r = g)
            arc_ended_rect(tail_across, tail_flats, tail_straight);
}

module step_profile(g = 0) {
    offset(r = g)
        hull() {
            intersection() {
                circle(d = step_diameter);
                translate([-step_diameter, 0])
                    square([2 * step_diameter, 2 * step_diameter], center = true);
            }
            translate([tail_offset, 0])
                arc_ended_rect(tail_across, tail_flats, tail_straight);
        }
}

// The widest the vacuum ever gets: the body circle plus the tail's ridge.
module envelope_profile(g = 0) {
    hull() {
        circle(d = body_diameter + 2 * g);
        tail_profile(g);
    }
}

// --- the solid -------------------------------------------------------------

// `bleed` overlaps the sections into each other. Used as a subtractive plug, sections
// that merely touch leave a film across the join in OpenSCAD's preview.
module vacuum_solid(g = 0, bleed = 0) {
    linear_extrude(total_height)
        tail_profile(g);

    translate([0, 0, step_z - bleed])
        linear_extrude(step_height + 2 * bleed)
            step_profile(g);

    for (i = [0 : ring_count - 1])
        translate([0, 0, slope_z + i * ring_height - bleed])
            cylinder(h = ring_height + 2 * bleed,
                     d = body_diameter - (ring_count - i) * ring_step + 2 * g);

    translate([0, 0, body_z - bleed])
        cylinder(h = body_length + bleed, d = body_diameter + 2 * g);
}
