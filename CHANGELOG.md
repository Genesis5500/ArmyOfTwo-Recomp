# Changelog

## v0.1.0 — first public release

- Initial public release of the Army of Two recompilation (ReXGlue, D3D12).
- Prebuilt Windows x64 release package: extract, supply your own dumped game files, run
  `play.bat`.
- Performance: identified the renderer as GPU-fill-bound; `resolution_scale = 1` holds a
  locked ~30 fps (vs ~14–19 fps at `resolution_scale = 2`). `native_2x_msaa` +
  `anisotropic_override = 5` recover sharpness at near-zero cost. See
  [docs/PERFORMANCE.md](docs/PERFORMANCE.md).
- Added a cvar-gated per-draw CPU profiler (`d3d12_draw_phase_profile`) for diagnosing
  frame cost (off by default).
- Licensed under GPL-3.0.

> Early testing only: opening areas run; a full playthrough is not verified. Rendering and
> stability issues remain.
