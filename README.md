# 3d-models

Parametric OpenSCAD models for 3D printing, one directory per model.

Each directory holds `model.scad` (the deliverable and the source of truth),
`model.stl` (a by-product, committed because slicing happens on a separate
machine), and a `README.md` describing what the model is for and what is still
unmeasured. Working output — renders, reports, logs — lands in `build/` and is
gitignored.

## Toolchain

```sh
direnv allow          # or: nix develop
```

`printer.json` at the repo root is the printer profile every model is checked
against — minimum wall, bed size, fit clearance. It lives here rather than in
`~/.config` so a checkout on another machine still builds against the printer the
models were designed for.

The dev shell supplies `jq` everywhere and OpenSCAD on Linux only. On macOS
OpenSCAD comes from the desktop app — `brew install --cask openscad` — because
the modelling workflow needs its live preview and that one install already puts
the same binary on PATH as the CLI. Adding a second OpenSCAD from nixpkgs would
leave the GUI being watched and the CLI being driven on different versions. The
Linux side has no such conflict: there the GUI runs on a different host entirely.

Note `nixpkgs.openscad` is still the 2021.01 release, which predates the
`--summary` flags the build script depends on. The shell pins
`openscad-unstable`.

| Model | What it is |
| --- | --- |
| [scarlett-4i4-under-keyboard-mount](scarlett-4i4-under-keyboard-mount/) | Hangs a Focusrite Scarlett 4i4 4th gen under an 88-key keyboard, from one top arm of a Donner Z-type stand |

## Conventions

Every dimension is a named parameter at the top of the file, derived rather than
restated, so one edit cannot desynchronise the geometry. The geometry lives in
`module main()`, called on the last line. Each file states its print orientation,
whether supports are needed, and its longest unsupported span in a header
comment, because none of those are checked mechanically. Values that came off a
real object are marked `// measured`; guesses are marked `// placeholder`.
