@echo off
REM Launch the Army of Two recompilation.
REM
REM EDIT THIS: point GAME_DATA at YOUR legally-obtained extracted game folder
REM (the one containing AO2Game\ and default.xex). The default below assumes an
REM "artifacts\ArmyOfTwoExtracted" folder sitting next to this repo.
set "GAME_DATA=%~dp0..\artifacts\ArmyOfTwoExtracted"
REM
REM   --gpu_plugin xenos : the GPU backend
REM   --mnk_mode         : keyboard-as-controller (menus WASD + Space, Start = Enter).
REM                        Omit if you're using an XInput gamepad.
REM   --d3d12_adapter N  : (optional) force a specific GPU adapter by index.
"%~dp0out\build\win-amd64-release\armyof2.exe" ^
  --game_data_root "%GAME_DATA%" ^
  --gpu_plugin xenos ^
  --mnk_mode
