# Under-keyboard parts tray

An open shelf for a tuner, picks, a string winder and a wireless receiver, hung
from one of the top support arms of a **Donner Z-type keyboard stand** (the
60–85 cm model with casters, Amazon ASIN B09G2QK6B3) by the **same strap-and-band
scheme** as
[scarlett-4i4-under-keyboard-mount](../scarlett-4i4-under-keyboard-mount/): a
grooved band down the centre of the ceiling beds against the underside of the
arm, and two straps pass up through four slots and around it.

`model.scad` is the deliverable and the source of truth. `model.stl` is a
by-product, committed only because slicing happens on a different machine, and is
regenerated whenever a parameter changes.

## How open it is

Only the **floor and the ceiling are unbroken**. Everything else is open:

| | |
|---|---|
| Front | fully open — no lip, no stop |
| Rear | open above 31 mm (`rear_open_fraction`, half the inside height) — but at 150 mm deep the back is out of reach anyway |
| Sides | windowed, leaving a **9.6 mm kerb** above the floor |
| Floor, ceiling | solid — a hole in either is a hole a pick goes through |

**Nothing retains a loose item against the open front.** A pick or a spring clip
will slide out if the tray is knocked hard enough. That is a deliberate choice
for reach and for looks, not an oversight; a continuous front lip can be added
back as a parameter if it turns out to matter.

The ceiling is the part that mounts, so it is necessarily *above* the contents —
this is a shelf reached from the front, not a tray looked into from above. An
open top would mean hanging it beside the arm on a cantilever, which loads the
straps in torsion and is a different part.

## Fitting what goes in it

- **The floor is 220 × 150 mm.** Depth is the direction you have to reach into,
  so 150 mm is as far back as is worth having: past that you are working blind
  under a keyboard.
- **The clear height is not uniform.** 62 mm under the ceiling skin, but only
  **56.2 mm under the band** down the centre, because the band hangs lower. The
  band is 57 mm wide — set by the arm plus the strap slots either side of it — so
  it splits the space into three:

| Zone | Width | Depth | Height | Volume |
|---|---|---|---|---|
| Side, each | 81.5 mm | 150 mm | 62 mm | 758 cm³ |
| Centre, under the band | 57 mm | 150 mm | 56.2 mm | 481 cm³ |
| Total | 220 mm | 150 mm | — | **~2.0 L** |

The heights are `echo`ed by the model, so they follow `tray_height` if it is
changed. The ceiling is close above everything, so this is space to lay things
out in, not space to stack in.

## Structure

The load path is the **closed tube** made by ceiling, side walls and floor, which
is intact at every point along the arm. The rear wall carries nothing, which is
why it can be cut to half height without weakening anything, and the side windows
only remove material from the middle of a wall that is loaded at its edges.

The ceiling is a full plate rather than an arm-width band: with the arm running
front to back, a band alone would reach nothing but the rear wall, so the shell
has to hang off a plate that reaches the side walls. It is thin (3.2 mm) away
from the band and windowed.

## Dimensions

| | |
|---|---|
| Overall | 224.8 × 152.4 × 67.6 mm |
| Floor | 220 × 150 mm |
| Clear height | 62 mm, **56.2 mm under the band** |
| Usable volume | ~2.0 L |
| Rear wall | 31 mm above the floor |
| Side kerb | 9.6 mm above the floor |
| Drop below the arm's underside | **62.6 mm** |
| Thinnest wall | 2.4 mm |
| Solid volume | ~217 cm³ (≤ ~271 g in PLA — a hand calculation, not a slicer estimate) |

Printed on the rear face it occupies 224.8 × 67.6 mm of the 235 mm bed and stands
152.4 mm tall. **Width is now against its limit** — about 10 mm of bed is left, so
`tray_width` has nowhere left to go. Depth still has room: the print is 152.4 mm
tall against 250 mm of Z, and the arm has 245 mm of clear length. Height grows the
shallow axis of the footprint, so it is not bed-constrained either; what limits it
is how far down the tray may hang.

Floor and ceiling are both full-footprint plates, which is why the mass follows
the floor area so directly: 330 cm² of floor is 74% more than the 190 cm² this
started at, and the part went from ~179 g to ~271 g with it. That is heavier than
the 4i4 mount. Shrinking `tray_depth` is the only lever left that gives it back.

The footprint is what the part costs: floor and ceiling are both full-footprint
plates, so `tray_width` × `tray_depth` sets the mass almost linearly — roughly
1 g of PLA per 8 cm² of footprint before the walls. Shrink those two first if it
is too heavy.

Walls are 2.4 mm rather than the 4i4 mount's 4 mm: this shell carries a few
hundred grams of oddments rather than a 1 kg instrument.

### Measured

Nothing was measured for this part. Every dimension that has to match the real
world — arm width 30 mm, the hook socket's raised rim on the arm's underside, zip
ties 3 × 1 mm — is carried over from the 4i4 mount, where it was measured off the
same stand with calipers.

### Placeholder

`tray_width`, `tray_depth`, `tray_height`, `rear_open_fraction`, `side_rim` and
`ceiling_rim` are preferences, not fits. They are set to something usable so
there is a shape to react to; change them in live preview.

### Still unverified

An earlier, smaller revision (200 × 95 × 62 inside) was printed and came out
clean — no drooping window ends, no supports, nothing to clean up. What that
print showed was that it was **too small to lay things out in**, which is what
drove the current floor size. Nothing at the current size has been sliced or
printed.

Still open: whether the open front loses picks in practice, and whether a 224.8 mm
wide part clears everything on the outboard side of the arm on its way down. The
4i4 mount is 189.2 mm wide on the same stand and clears; the extra 35.6 mm here
has not been checked against the real thing.

**It needs its own arm.** At 152.4 mm along the arm it cannot share one with the
4i4 mount: together they want 274.2 mm of the 245 mm of clear arm. One part per
arm, left and right.

## Building

```sh
direnv allow          # or: nix develop
scripts/build.sh model.scad --profile ../printer.json     # from the 3d-print skill
```

That exports `model.stl`, renders five views into `build/`, and prints one JSON
report. `build/` is regenerable and gitignored.

The report checks five things only: the result is 3D, it is not empty, all views
rendered, it fits the bed, and the echoed thinnest wall clears two nozzle widths.
Manifoldness, disjoint bodies, overhang angles, and whether it actually prints are
**not** checked. The file adds asserts of its own: that the strap slots stay clear
of the end faces, that `side_rim` still leaves a side window, and that every
window is long enough for its own 45° taper.

For live tuning, open `model.scad` in the OpenSCAD desktop app and turn on
*Design → Automatic Reload and Preview*. Every dimension is a parameter at the
top of the file, so it also appears in the Customizer.

## Printing

**Stand it on the rear face** — rotate 90° about X in the slicer, or set
`orient_for_print = true` to export it already rotated. Every wall is then
vertical, with the load path inside the layers, and the first layer is the closed
ring of floor + side walls + ceiling with the rear wall filling most of it.

No supports, and **nothing is bridged**. Build direction is −Y, so each layer is
one cross-section through the depth of the tray, and any surface facing the rear
would be a downward-facing surface in the print. With no front lip the part never
closes in that direction — it simply ends — so the only such surfaces left are
the window ends, and those taper at 45° (`window_2d`) so they close one extrusion
at a time. `window_taper` raises that angle if a first print shows them drooping.

The **strap slots** still close unsupported as they end — 3 mm across, 42 mm² each.
That is the same detail the 4i4 mount printed acceptably.

Nothing here has been sliced. Print time, filament use, and whether a slicer
accepts the file are all unverified.

## Assembly

1. **Strap the empty tray to the arm**, with a ~1.5 mm rubber strip (shelf liner,
   inner tube) laid in the groove. The strip is what stops the tray creeping
   along the arm when it is knocked: bare nylon on painted steel gives a friction
   coefficient of roughly 0.25, the rubber takes it to ~0.8. Nothing pulls on a
   tray the way cables pull on the interface, so the margin here is not tight —
   but the strip costs nothing.
2. Tighten before filling it. A zip tie's head ends up under the ceiling, inside
   the tray.
