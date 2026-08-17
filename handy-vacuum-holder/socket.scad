// The socket that holds the vacuum, with nothing about how it is mounted. Centred on
// the vacuum's axis at the origin, so a mount can put it wherever it likes.
//
// Shared: every mount includes this rather than restating the socket. There is now more
// than one mount, and the socket is the part that has been fitted against the real
// vacuum -- it should not be possible for one mount to drift from another.
//
// The bore is not designed, it is subtracted: it is the vacuum solid from
// ../mystick-neo-reference/vacuum.scad, grown by a clearance. That works because the
// vacuum's cross-section never shrinks going up -- on the way down, everything that
// passes a given height is narrower than what finally rests there -- so the bore can
// follow the profile exactly and every upward-facing surface in it carries load: the
// step section's shoulder plus all four ring shoulders.

include <../mystick-neo-reference/vacuum.scad>

/* [Socket] */
throat_height = 12;  // sleeve around the tail, below the step section's shoulder
mouth_height  = 25;  // straight collar above the slope. With the nozzle left on the
                     // vacuum stands 320 mm tall, and this is what resists tilt.

/* [Fit] */
// Measured against a printed part, not derived. The first print went together but was
// tight all over; 0.5 is the correction.
vacuum_clearance = 0.5;

// Extra, in the throat only. The tail's end cap leaves a small step at its joint and it
// snags going through. The throat locates nothing -- the vacuum hangs on the ring
// shoulders and is steadied by the mouth -- so slack here is free.
throat_relief = 0.5;

// Extra, over the step section only. It went in under its own weight but rubbed. Kept
// separate from vacuum_clearance rather than raising that, because the ring shoulders
// and the mouth already fit well and there is no reason to loosen them too.
step_relief = 0.25;

/* [Print] */
wall      = 3;
clearance = 0.2;  // printer fit clearance, for mount hardware rather than the vacuum

/* [Hidden] */
eps = 0.01;

// --- derived ---------------------------------------------------------------

// Drop the vacuum in until its step section starts at the top of the throat.
dock_z      = throat_height - step_z;

socket_h    = throat_height + step_height + slope_height + mouth_height;

// Half-depth of the socket at its back, where the plain body circle governs. The tail's
// ridge is on the other side, so a mount can sit this close in.
socket_back = body_diameter / 2 + vacuum_clearance + wall;

// --- geometry --------------------------------------------------------------

// A straight prism. Nothing overhangs and every ledge inside is fully backed.
module socket_shell() {
    linear_extrude(socket_h)
        envelope_profile(vacuum_clearance + wall);
}

// Kept separate from the shell so a mount can union its own structure in first and have
// it hollowed out by the same cut.
module socket_void() {
    translate([0, 0, dock_z])
        vacuum_solid(vacuum_clearance, bleed = 0.05);

    translate([0, 0, -1])
        linear_extrude(throat_height + 1 + 0.05)
            tail_profile(vacuum_clearance + throat_relief);

    // Ends at the first ring, so the ring shoulders above are untouched.
    translate([0, 0, throat_height - 0.05])
        linear_extrude(step_height + 0.1)
            step_profile(vacuum_clearance + step_relief);
}

// The socket alone, for trying the vacuum in before committing to a whole mount.
module socket_fit_check(from, to) {
    intersection() {
        difference() {
            socket_shell();
            socket_void();
        }
        translate([-socket_back - 1, -socket_back - 1, from])
            cube([2 * socket_back + 2, 2 * socket_back + 2, to - from]);
    }
}
