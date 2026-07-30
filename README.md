# 3d-models

Parametric OpenSCAD models for 3D printing, one directory per model.

Each directory holds `model.scad` (the deliverable and the source of truth),
`model.stl` (a by-product, committed because slicing happens on a separate
machine), and a `README.md` describing what the model is for and what is still
unmeasured. Working output — renders, reports, logs — lands in `build/` and is
gitignored.

| Model | What it is |
|---|---|
| [scarlett-4i4-under-keyboard-mount](scarlett-4i4-under-keyboard-mount/) | Hangs a Focusrite Scarlett 4i4 4th gen under an 88-key keyboard, from one top arm of a Donner Z-type stand |

## Conventions

Every dimension is a named parameter at the top of the file, derived rather than
restated, so one edit cannot desynchronise the geometry. The geometry lives in
`module main()`, called on the last line. Each file states its print orientation,
whether supports are needed, and its longest unsupported span in a header
comment, because none of those are checked mechanically. Values that came off a
real object are marked `// measured`; guesses are marked `// placeholder`.
