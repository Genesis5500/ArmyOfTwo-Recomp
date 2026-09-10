# Building & packaging (Windows / Linux / macOS)

The recomp compiles natively on all three platforms. **You must build on the target OS**
(with your own game dump present) — the codegen step turns *your* `default.xex` into C++,
so a build machine without the game files can't produce a runnable binary, and cross-OS
builds aren't supported here.

> **Linux/macOS status:** experimental. Those platforms use the **Vulkan** GPU backend
> (MoltenVK on macOS); Army of Two has so far only been validated on Windows/Direct3D 12.
> Expect to shake out Vulkan-specific issues.

## Common prerequisites

- **CMake ≥ 3.25**, **Ninja**, **Clang** (the presets use clang/clang++).
- The **[ArmyOfTwo-Recomp-rexglue](https://github.com/Genesis5500/ArmyOfTwo-Recomp-rexglue)**
  SDK fork checked out somewhere; pass its path as `-DREXSDK_DIR=`.
- Your own legally-dumped Army of Two. Set `game_root` / `entrypoint.file_path` in
  `armyof2_manifest.toml` to your extracted copy before the first build.

## Build

Windows:
```bash
cmake --preset win-amd64-release -DREXSDK_DIR=<path-to-ArmyOfTwo-Recomp-rexglue>
cmake --build out/build/win-amd64-release
```

Linux (needs the Vulkan loader + headers; a glibc 2.35 / Ubuntu 22.04-class toolchain
matches the SDK's CI floor):
```bash
cmake --preset linux-amd64-release -DREXSDK_DIR=<path-to-ArmyOfTwo-Recomp-rexglue>
cmake --build out/build/linux-amd64-release
```

macOS (needs Xcode command-line tools + the Vulkan SDK/MoltenVK; use `mac-arm64-release`
on Apple Silicon):
```bash
cmake --preset mac-amd64-release -DREXSDK_DIR=<path-to-ArmyOfTwo-Recomp-rexglue>
cmake --build out/build/mac-amd64-release
```

## Run

```bash
./out/build/<preset>/armyof2 --game_data_root <your-extracted-game-folder> --gpu_plugin xenos --mnk_mode
```

The `xenos` plugin ships both D3D12 and Vulkan backends; on Linux/macOS it uses Vulkan
automatically (no Direct3D 12). If startup can't pick a backend, run `armyof2 --help` and
look for a `--gpu_backend` / backend-selection flag and set it to `vulkan`.

## Package a release ZIP/tarball

Mirror the Windows layout. First see what shared libraries landed next to the exe:

```bash
ls out/build/<preset>/          # note the runtime libs alongside 'armyof2[.exe]'
```

Bundle the executable **plus those runtime libraries** (Windows: `rexruntime.dll`,
`rexgpu-xenos.dll`; Linux: `librexruntime.so`, `rexgpu-xenos*.so`; macOS: the `.dylib`
equivalents — copy whatever the build placed there), together with:

- `armyof2.toml` (keep `resolution_scale = 1`, `native_2x_msaa = true`,
  `anisotropic_override = 5`),
- a launcher (`play.sh` below, or `play.bat` on Windows),
- `QUICKSTART.txt`, `LICENSE`,
- an empty `ArmyOfTwoExtracted/` folder with a `PLACE EXTRACTED GAME FILES HERE.txt`.

macOS/Linux may also need to co-locate MoltenVK / Vulkan loader libraries if they aren't
found system-wide — check `ldd`/`otool -L` on the built `armyof2` for unresolved libs and
bundle those.

`play.sh`:
```sh
#!/bin/sh
DIR="$(cd "$(dirname "$0")" && pwd)"
# Put your extracted game (AO2Game/ + default.xex) in ArmyOfTwoExtracted next to this file,
# or set GAME_DATA to your own path.
GAME_DATA="$DIR/ArmyOfTwoExtracted"
exec "$DIR/armyof2" --game_data_root "$GAME_DATA" --gpu_plugin xenos --mnk_mode
```
(`chmod +x play.sh`; on macOS also `chmod +x armyof2`.)

Then tar it up and attach to the release:
```bash
tar -C <staging-parent> -czf ArmyOfTwo-Recomp-v0.1.0-linux-x64.tar.gz ArmyOfTwo-Recomp-v0.1.0-linux-x64
gh release upload v0.1.0 ArmyOfTwo-Recomp-v0.1.0-linux-x64.tar.gz --repo Genesis5500/ArmyOfTwo-Recomp
```

If a Linux/macOS build actually runs, please note it in an issue/CHANGELOG so the status
line above can be updated from "experimental."
