# Army of Two Recompilation

An experimental native PC port of the Xbox 360 game **Army of Two**, built with static
recompilation via the [ReXGlue SDK](https://github.com/) (PowerPC → portable C++, rendered
through a native D3D12/Vulkan backend — no runtime 360 CPU interpretation).

This repository contains **only** the host/glue code and build configuration. It ships
**no game code and no game assets**. You build it against your own legally-dumped copy of
the game; the recompiler turns *your* `default.xex` into C++ locally on your machine.

> **Development status:** early. The opening areas run; a full playthrough is not verified.
> Expect bugs and rough edges. Contributions and reports welcome.

---

## Legal

This project is not affiliated with nor endorsed by Electronic Arts, Microsoft, or Xbox.
It is an independent project for educational and preservation purposes. It is **not**
intended to promote piracy or the unauthorized use of copyrighted material.

You must own an original copy of Army of Two and dump it yourself. **No game files are
included in this repository, and none will be provided.** The recompiled code produced
from your dump is a derivative of copyrighted game code — keep it local; do not
redistribute it (the build output folders are git-ignored for this reason).

## What you need to supply

A legally-obtained copy of **Army of Two (Xbox 360)**, as any of:

- an extracted game folder (containing `default.xex` and the `AO2Game/` data), **or**
- `default.xex`, **or**
- an XDVDFS ISO, **or**
- a GOD container.

Place your extracted copy at `../artifacts/ArmyOfTwoExtracted` (a folder next to this
repo), or edit the path in `armyof2_manifest.toml` (`game_root` / `entrypoint.file_path`)
and in `play.bat` to point at your own location.

## Dependencies

- **ReXGlue SDK 0.10.0** — the recompiler + runtime this project builds against.
  Provide it either by installing the SDK package (so CMake's `find_package(rexglue 0.10.0)`
  finds it) or by pointing the build at an SDK source/checkout:
  `-DREXSDK_DIR=<path-to-rexglue-sdk>`.
- **CMake ≥ 3.25**, **Ninja**, and **Clang** (the presets use clang/clang++).

## Build

```bash
# Configure (Release; add -DREXSDK_DIR=<sdk> if the SDK isn't installed on the prefix path)
cmake --preset win-amd64-release

# Build. This also runs codegen: it reads armyof2_manifest.toml and recompiles your
# default.xex into generated/ (this can take a while on the first run).
cmake --build out/build/win-amd64-release
```

The build produces `out/build/win-amd64-release/armyof2.exe` plus the staged GPU plugin
and runtime DLLs.

## Run

```bash
play.bat
```

Or directly:

```bash
out\build\win-amd64-release\armyof2.exe --game_data_root <your-extracted-game-folder> --gpu_plugin xenos --mnk_mode
```

- `--mnk_mode` enables keyboard-as-controller (menus: WASD + Space; Start = Enter). Omit
  it if you're using an XInput gamepad.
- First launch performs shader preparation (parallel compile + cache); later launches are
  faster.

## Performance & settings

Settings live in `armyof2.toml` next to the exe (or the in-game menus: **F4** full menu,
**F3** PC settings). See [docs/PERFORMANCE.md](docs/PERFORMANCE.md) for the details, but the
short version:

- **`resolution_scale = 1`** — recommended. The game is GPU-fill-bound; `resolution_scale = 2`
  is 2× supersampling (4× the pixels) and roughly halves the framerate.
- **`native_2x_msaa = true`** and **`anisotropic_override = 5`** — cheap image-quality wins
  that recover most of the sharpness at ~no framerate cost.

## Credits

Built on the work of the Xbox 360 recompilation community:

- **ReXGlue SDK** (Tom "crack" and contributors) — the recompiler + runtime.
- **[Xenia](https://github.com/xenia-project/xenia)** — GPU emulation research the `xenos`
  backend derives from.
- **[XenonRecomp / XenosRecomp](https://github.com/hedge-dev/XenonRecomp)** — static
  recompilation approach.

Army of Two is © Electronic Arts. This project claims no ownership of it.

## License

The host/glue code in this repository is licensed under the [MIT License](LICENSE). The
ReXGlue SDK and any game code/assets are covered by their own respective licenses/owners.
