# Performance & recommended settings

Settings live in `armyof2.toml` (next to `armyof2.exe`), or change them live in-game with
**F4** (full menu) / **F3** (PC settings).

## TL;DR

```toml
resolution_scale   = 1     # locked ~30 fps. DO NOT set to 2 unless you have GPU to spare.
native_2x_msaa     = true  # cheap edge anti-aliasing
anisotropic_override = 5    # 16x anisotropic: sharp textures at oblique angles
```

## Why `resolution_scale = 1`

Army of Two is a native 30 fps title. On this renderer it is **GPU-fill-bound**, not
CPU-bound: profiling the command processor shows per-draw CPU work is only ~3 µs/draw
(~6 ms/frame for ~2000 draws), while the frame is otherwise dominated by the GPU.

- `resolution_scale = 2` renders at **2× supersampling = 4× the pixels**. That blows the
  GPU frame budget to ~50–70 ms and the CPU ends up blocking ~30 ms/frame waiting on the
  GPU fence → **~14–19 fps**.
- `resolution_scale = 1` keeps the GPU under budget → the game holds its **locked ~30 fps**
  (frame time pinned at ~33 ms), with the GPU idle-fence wait dropping to **0 ms**.

That single value is by far the biggest performance lever.

## Recovering sharpness without the framerate cost

`resolution_scale = 1` is softer than 2× supersampling. Because the GPU has spare headroom
under the 30 fps cap, you can add these for essentially free:

- **`native_2x_msaa = true`** — real geometry-edge anti-aliasing. Multisamples edges only
  (shades once), so it's far cheaper than supersampling.
- **`anisotropic_override = 5`** — forces 16× anisotropic filtering (values map
  1/2/4/8/16×). Keeps ground and wall textures crisp at oblique viewing angles.

Measured: enabling both kept the frame time at ~33 ms (still a locked ~30 fps).

## Other notes

- `readback_resolve = "fast"` is the Army of Two per-game profile for correct bloom (fixes
  CPU-readback over-brightness). It does not meaningfully affect framerate.
- The discrete GPU is selected automatically (highest dedicated VRAM). Force one with
  `--d3d12_adapter N` if needed.

## Diagnosing it yourself

The `xenos` GPU plugin has a cvar-gated per-draw profiler: set
`d3d12_draw_phase_profile = true` in `armyof2.toml` to log a per-draw CPU phase breakdown
(and per-frame fence-wait) every ~120 frames. (Requires an SDK build that includes the
instrumentation.)
