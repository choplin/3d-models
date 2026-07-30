# Scarlett 4i4 under-keyboard mount

Gets a **Focusrite Scarlett 4i4 4th gen** off the desk and under the keyboard, by
hanging it from one of the top support arms of a **Donner Z-type keyboard stand**
(the 60–85 cm model with casters, Amazon ASIN B09G2QK6B3), carrying an 88-key
board.

`model.scad` is the deliverable and the source of truth. `model.stl` is a
by-product, committed only because slicing happens on a different machine, and is
regenerated whenever a parameter changes.

![cross-section](docs/cross-section.svg)

## What it is for

The stand's two top arms run **front to back**, one on each side frame, and the
keyboard lies across them. The mount straddles one arm, so the unit hangs
directly below it with its front panel facing the player, near one end of the
keyboard and clear of the player's knees.

Front and rear are open, so the front-panel jacks and the rear USB-C and line
outputs stay reachable. The **top panel does not** — that is inherent to putting
the unit under a keyboard, not a limitation of this bracket.

## How it mounts, and why not otherwise

A grooved band down the centre of the ceiling beds against the **underside** of
the arm, and two straps (zip ties or hook-and-loop) pass up through four slots
and around the arm. The straps carry the whole load.

Two more obvious approaches were tried on paper first and rejected:

- **Hooking over the arm.** Hanging from a bar needs material *above* it, which
  would sit between the arm and the keyboard and lift one side of the keyboard.
  Worse, a downward-open hook cannot be lowered onto an arm that is captive in
  the frame: the mount's own floor collides with the arm on the way down. Making
  the whole part straddle a full-width slot to clear it would gut the structure.
- **Bolted clamp jaws.** Stronger and immune to strap relaxation, but it needs
  the arm's cross-section to be matched closely, adds hardware, and adds print
  time. Held in reserve; see *Known weakness* below.

Strapping also has the property that it barely cares about the arm's
cross-section, which mattered while the stand was still unmeasured.

The ceiling is a **full plate**, not just a band the width of the arm. With the
arm running front to back, a band alone would only reach the front lip and rear
stop, so the shell has to hang from a plate that reaches the side walls. The
plate is thin (3.2 mm) away from the band and windowed to keep the mass down.

## Known weakness

Plugging and unplugging front-panel cables pushes and pulls **along** the arm, so
the groove walls have nothing to bear against and only strap friction resists it.
Bare nylon on painted steel gives roughly 0.25, so two ties at ~300 N give ~75 N
against a ~50 N pull — too close for comfort.

**Lay a ~1.5 mm rubber strip in the groove.** A scrap of shelf liner or inner
tube will do. It takes the coefficient to ~0.8, i.e. ~240 N. `groove_depth` is
sized to swallow the strip and still leave positive engagement. Four ties instead
of two helps as well.

The failure mode is gradual creep along the arm, not breakage: visible and
re-tightenable rather than sudden. Nylon ties do relax, so re-tighten after a few
weeks.

Everything else has a wide margin. By hand calculation, at ~0.96 kg total the
strap tension runs ~90× under its rating and the ceiling band's bending stress
~110× under PLA's strength.

## Dimensions

| | |
|---|---|
| Overall | 189.2 × 135.8 × 75.7 mm |
| Drop below the arm's underside | **70.7 mm** |
| Thinnest wall | 2.5 mm |
| Solid volume | 182.5 cm³ (≤ ~226 g in PLA — an upper bound, not a slicer estimate) |

The drop is the number that matters on this stand: the side frame's upright is
angled, so the clear length along the arm shrinks the lower you go. There is
245 mm of clear arm between the frame junction and the arm's tip, against the
mount's 135.8 mm, so it fits with room.

### Measured

- Arm width 30 mm, square section.
- 245 mm clear along the arm from the frame junction to the tip.
- A hook socket on the arm's underside with a ~1 mm raised rim. Rather than
  positioning the mount to dodge it, the groove floor carries a relief channel
  down its centre, so the arm beds on two shoulders and the rim has somewhere to
  go wherever it sits along the arm.
- A rubber pad covering roughly the outer 100 mm of the arm. Place the straps
  clear of it and the keyboard is not lifted at all.

### Still placeholders

`device_width`, `device_depth` and `device_height` are Focusrite's published
figures (180 × 129 × 59 mm), which tend to be maximum-envelope numbers. **The
cavity is provisional until they are measured.** The height matters most: the 3rd
gen measured 47.5 mm, and if this one is similar the drop below the arm falls to
about 60 mm.

## Building

Needs the OpenSCAD desktop application and `jq`. On macOS:

```sh
brew install --cask openscad
brew install jq
```

```sh
scripts/build.sh model.scad     # from the 3d-print skill
```

That exports `model.stl`, renders five views into `build/`, and prints one JSON
report. `build/` is regenerable and gitignored.

The report checks four things only: the result is 3D, it is not empty, it fits
the bed, and the echoed thinnest wall clears two nozzle widths. Manifoldness,
disjoint bodies, overhang angles, and whether it actually prints are **not**
checked.

For live tuning, open `model.scad` in the OpenSCAD desktop app and turn on
*Design → Automatic Reload and Preview*. Every dimension is a parameter at the
top of the file, so it also appears in the Customizer.

## Printing

**Stand it on the rear face** — rotate 90° about X in the slicer, or set
`orient_for_print = true` to export it already rotated. The part is then a
rectangular tube standing on a closed perimeter ring: every wall vertical, the
load path inside the layers rather than across them, and good bed adhesion.

No supports. Longest unsupported span is 3 mm.

That orientation makes the build direction −Y, so each layer is one cross-section
through the depth of the box, and **every lightening window has an end that
closes in the build direction**. A square-ended window would have to be bridged
there — the floor window would have been a 149 mm bridge. So all window ends
taper at 45° (`window_2d`) and the floor window is split into three.
`window_taper` raises that angle if the ends droop on a first print.

Nothing here has been sliced. Print time, filament use, and whether a slicer
accepts the file are all unverified.

## Assembly

1. **Strap the empty mount to the arm first**, with the rubber strip in the
   groove. A zip tie's head ends up under the ceiling, in the headroom above the
   unit, so it has to be tightened before the unit goes in.
2. **Slide the Scarlett in from the front**, tilting it over the 3 mm lip. The
   4.5 mm of headroom exists for exactly that. It stops against the rear stop.
