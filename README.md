# Army of Two Recompilation

An experimental native PC port of **Army of Two** for Xbox 360.

**Windows x64 · Direct3D 12 · PowerPC static recompilation (ReXGlue)**

[Download](https://github.com/Genesis5500/ArmyOfTwo-Recomp-rexglue/releases/latest) ·
[Report an issue](https://github.com/Genesis5500/ArmyOfTwo-Recomp-rexglue/issues) ·
[Changelog](CHANGELOG.md) · [Build from source](#build-from-source)

> **Important**
>
> This project is still in early testing. The opening areas have been tested; a complete
> playthrough has not. Rendering and stability issues remain. **You must supply your own
> game files** — none are included, and none will be provided.

## Start playing

1. Download and extract the Windows release ZIP to a writable folder.
2. Put your own **legally-dumped** copy of Army of Two (an extracted game folder containing
   `AO2Game/` and `default.xex`) in an `ArmyOfTwoExtracted` folder next to the extracted
   release — or edit the path at the top of `play.bat`.
3. Run **`play.bat`**.

No Python or Visual Studio installation is needed for the release package. The first launch
performs shader preparation (parallel compile + cache); later launches reuse the cache.

| Requirement | Supported configuration |
|-------------|-------------------------|
| System      | Windows x64, AVX-capable CPU, Direct3D 12 graphics driver |
| Game data   | Your own dumped Army of Two (extracted folder, `default.xex`, XDVDFS ISO, or GOD). Disc 1 required to start. |
| Runtime     | Microsoft Visual C++ 2015–2022 Redistributable (bundled app-local; install the latest if a DLL error appears) |

## Features

| Feature | What to expect |
|---------|----------------|
| Renderer | Native D3D12 backend via the ReXGlue `xenos` GPU plugin; ahead-of-time shader cache |
| Input | XInput controller, or keyboard with `--mnk_mode` (menus: WASD + Space, Start = Enter) |
| Graphics settings | Internal `resolution_scale`, `native_2x_msaa`, `anisotropic_override`, vsync — in `armyof2.toml` or the in-game **F4**/**F3** menus |
| Performance | Locked ~30 fps at `resolution_scale = 1` on modest GPUs; see [docs/PERFORMANCE.md](docs/PERFORMANCE.md) |
| Diagnostics | Optional cvar-gated per-draw CPU profiler (`d3d12_draw_phase_profile`), off by default |

## Performance

Army of Two is a native 30 fps title and is GPU-fill-bound on this renderer. Keep
**`resolution_scale = 1`** for a locked ~30 fps; `resolution_scale = 2` is 2× supersampling
(4× the pixels) and roughly halves the framerate. `native_2x_msaa = true` and
`anisotropic_override = 5` recover most of the sharpness for near-zero cost. Full details in
[docs/PERFORMANCE.md](docs/PERFORMANCE.md).

## Build from source

Building requires the **ReXGlue SDK 0.10.0**, **CMake ≥ 3.25**, **Ninja**, and **Clang**.
The recompiler turns *your own* `default.xex` into C++ locally; the generated code is
git-ignored and is never distributed.

```bash
# Point the build at your ReXGlue SDK checkout (or install it so find_package sees it)
cmake --preset win-amd64-release -DREXSDK_DIR=<path-to-rexglue-sdk>

# Build (also runs codegen: recompiles your default.xex per armyof2_manifest.toml)
cmake --build out/build/win-amd64-release
```

Then run `play.bat`, or `armyof2.exe --game_data_root <your-game-folder> --gpu_plugin xenos --mnk_mode`.

Set your game path in `armyof2_manifest.toml` (`game_root` / `entrypoint.file_path`) before
the first build.

## Credits

With research and tools from the Xbox 360 recompilation community:

- **ReXGlue SDK** (Tom "crack" and contributors) — recompiler + runtime.
- **[Xenia](https://github.com/xenia-project/xenia)** — GPU emulation research the `xenos`
  backend derives from.
- **[XenonRecomp / XenosRecomp](https://github.com/hedge-dev/XenonRecomp)** — static
  recompilation approach.

Army of Two and its assets belong to their respective owners (© Electronic Arts). This is an
unofficial project, not affiliated with nor endorsed by EA, Microsoft, or Xbox, created for
educational and preservation purposes. It is **not** intended to promote piracy or the
unauthorized use of copyrighted material. Supply data extracted from your own disc; do not
distribute game executables, resource archives, textures, audio, video, or generated game
code.

## License

The host/glue code in this repository is licensed under **[GPL-3.0](LICENSE)**. The ReXGlue
SDK and any game code/assets are covered by their own respective licenses/owners.
