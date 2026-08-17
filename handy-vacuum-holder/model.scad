// Holder for a Mitea Lab MyStick Neo (JK-1700R3) on a 25.3 mm square desk leg.
// The vacuum stands nozzle-up and is lowered in from above.
//
// The socket lives in socket.scad and is shared with the other mounts; this file is
// only the leg clamp and where the socket sits relative to it.
//
// The collar is a C, open on the side away from the socket. It goes on the leg
// sideways -- a desk leg is captive top and bottom, so nothing can be threaded on from
// an end -- and is then closed by a tapered key.
//
// The taper is on the collar's own outer flanks and the key grips those, so the squeeze
// lands directly over the leg. An earlier version put the taper on ears sticking out
// past the leg, which is the conventional split-collar layout, but it makes the side
// walls work as bent cantilevers to reach the leg and the printed part felt soft.
// Clamping here is a matter of stiffness rather than force -- the wedge can always be
// driven further -- so shortening the load path is what buys grip.
//
// Fitting: collar onto the leg, key slid on horizontally from the open side while it is
// low on the taper, then tapped UPWARDS to clamp. Force comes from wedge geometry
// rather than elastic preload, so there is nothing for PLA to creep out of, and the
// 1.4 deg taper is well inside self-locking. The key's back plate covers the collar's
// mouth as a side effect, which stops the leg backing out of it.
//
// Print orientation: upright, exactly as modelled, flat on the bed. No supports.
//
// Two parts. Set part = "holster" and part = "key" to export them separately.

include <socket.scad>

/* [Part] */
// "holster" and "key" are what you export and print. "assembly" shows the key seated
// where it ends up, which hides the collar's open mouth behind the key's back plate --
// use "exploded" to see the two bodies apart. "fitcheck" is the socket on its own, for
// trying the vacuum in before committing to the full part.
part = "assembly";  // ["assembly", "exploded", "holster", "key", "fitcheck"]

// How far the key is drawn away from the collar in the exploded view. Display only.
explode = 55;

/* [Fit check] */
// Everything that decides whether the vacuum sits properly is below the mouth: the tail
// passing the throat, the step section's shoulder, and the four ring shoulders. The
// default keeps 10 mm of mouth above the top ring, enough to feel whether the body is
// snug, and throws away the rest -- most of the plastic and none of the information.
fit_from = 0;
fit_to   = 47;

/* [Desk leg] */
tube_x = 25.3;  // measured -- leg depth, front to back
tube_y = 25.3;  // measured -- leg width, side to side

/* [Collar] */
collar_height = 60;
// Extra width per side at the TOP of the collar's outer flanks. This is the wedge: the
// key's span grows at the same rate, so driving it up squeezes.
collar_taper  = 1.5;
// How far each jaw tip reaches back over the open face. 0 leaves the mouth wider than
// the leg, so the collar goes on sideways with no force at all -- which it has to,
// because a desk leg is captive at both ends. Anything above 0 turns fitting into a
// spring-it-open operation on a 3 mm PLA section, and earns nothing: the key's back
// plate already covers the mouth.
jaw_lip       = 0;
arm_gap       = 3;    // clear space between collar and socket
spine_width   = 24;

/* [Key] */
key_height    = 30;
// 5, not 3. The arms are cantilevers and the clamping reaction bends them outwards;
// stiffness goes as the cube of this, so 3 -> 5 is about 4.6x. At 3 mm they deflected
// further than the wedge's whole travel, so the far end never clamped and the key
// pivoted on whatever did touch.
key_wall      = 5;
// The +X end of the arms. Kept short deliberately: deflection goes as the cube of the
// free length, so reaching all the way across the collar costs far more in splay than
// it wins in contact area. This still covers most of the leg's width.
key_arm_reach = 8;
// Uniform gap between the key and the collar flanks with the key sitting at the bottom.
// With the two tapers matched this really is a slip-fit clearance, and the key has to
// travel (key_clearance + clearance) / taper before it bites.
key_clearance = 0.3;
key_seated_z  = 20;   // display only: where the key ends up once driven home

// --- derived ---------------------------------------------------------------

tube_ix   = tube_x / 2 + clearance;
tube_iy   = tube_y / 2 + clearance;
collar_ox = tube_ix + wall;
collar_oy = tube_iy + wall;

socket_x  = collar_ox + arm_gap + socket_back;

taper_rate = collar_taper / collar_height;
key_inner  = collar_oy + key_clearance;   // at the key's own base
key_rise   = key_height * taper_rate;     // how much the key's own faces open over it

// How far the key has to be driven up before it bites. With matched tapers the gap is
// uniform, so this is the same everywhere on the face rather than only at one edge.
// Echoed because the key has to end up inside the collar, and 0.1 mm of print error on
// the flanks moves it 4 mm.
key_home = (key_clearance + clearance) / taper_rate;

echo(min_wall = min(wall, key_wall));
echo(socket_height = socket_h, reach_from_leg_centre = socket_x);
echo(key_home_z = key_home, key_top_at_home = key_home + key_height,
     fits_in_collar = key_home + key_height <= collar_height);

// The vacuum's arbitrary tail and body lengths have to outrun the socket at both ends,
// or the bore would stop inside it and leave a lid.
echo(tail_clears_bottom = tail_length > throat_height,
     body_clears_top    = dock_z + total_height > socket_h);

// --- leg collar ------------------------------------------------------------

// C-collar around the leg, open on -X. The bore stays a constant square; only the outer
// flanks taper, widening going UP, and those flanks sit directly over the leg.
//
// The taper direction is deliberate. What sets the clamp is the key's position relative
// to the collar, not either one's absolute movement -- so a downward shock on the
// socket, with the key lagging on its own inertia, moves the key UP the taper and
// tightens. The other way round, the same shock would walk it loose. The vacuum is
// pushed in from above, so downward shocks are the load this thing actually sees. The
// key's own weight pulls the other way, but at ~0.04 N against a wedge needing newtons
// to shift, it does not signify.
module collar() {
    difference() {
        hull() {
            linear_extrude(eps)
                square([2 * collar_ox, 2 * collar_oy], center = true);
            translate([0, 0, collar_height - eps])
                linear_extrude(eps)
                    square([2 * collar_ox, 2 * (collar_oy + collar_taper)],
                           center = true);
        }

        translate([0, 0, -eps])
            linear_extrude(collar_height + 2 * eps)
                square([2 * tube_ix, 2 * tube_iy], center = true);

        translate([-collar_ox - eps, -(tube_iy - jaw_lip), -eps])
            cube([wall + 2 * eps, 2 * (tube_iy - jaw_lip), collar_height + 2 * eps]);
    }
}

module spine() {
    translate([tube_ix, -spine_width / 2, 0])
        cube([socket_x - tube_ix, spine_width, socket_h]);
}

// The arms' inner faces carry the SAME taper as the collar's flanks. That is the point:
// a tapered flank against a parallel arm can only touch along one line, at the arm's top
// edge, however hard it is driven. Matched, the two mate over the full face and the
// interference is uniform, so driving the key up loads the whole contact patch at once
// instead of pivoting on an edge.
//
// The arms run back over the plate rather than butting onto its face. Two solids that
// only meet on a plane are not a union -- CGAL leaves them as separate bodies and the
// part prints as three loose pieces.
module key_arm() {
    x0  = -(collar_ox + key_wall);
    len = key_arm_reach - x0;

    hull() {
        translate([x0, key_inner, 0])
            cube([len, key_wall, eps]);
        translate([x0, key_inner + key_rise, key_height - eps])
            cube([len, key_wall, eps]);
    }
}

module key() {
    key_arm();
    mirror([0, 1, 0]) key_arm();

    back_half = key_inner + key_rise + key_wall;
    translate([-(collar_ox + key_wall), -back_half, 0])
        cube([key_wall, 2 * back_half, key_height]);
}

// The bore is cut from the whole union: the spine runs to the socket axis to make a
// strong joint, so it has to be hollowed out afterwards rather than kept clear.
module holster_body() {
    difference() {
        union() {
            collar();
            spine();
            translate([socket_x, 0, 0]) socket_shell();
        }
        translate([socket_x, 0, 0]) socket_void();
    }
}

module main() {
    if (part == "holster")  holster_body();
    if (part == "key")      key();
    if (part == "fitcheck") translate([socket_x, 0, 0]) socket_fit_check(fit_from, fit_to);

    if (part == "assembly") {
        holster_body();
        translate([0, 0, key_seated_z]) key();
    }

    // Colours are preview-only and carry no geometry.
    if (part == "exploded") {
        color("SteelBlue") holster_body();
        color("IndianRed") translate([-explode, 0, key_seated_z]) key();
    }
}

main();
