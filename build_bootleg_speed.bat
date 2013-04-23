del rom\speed_patched.gba
del rom\output.gba
cp rom\speed.gba rom\output.gba
armips.exe asm\DecompressedGfx.asm
armips.exe asm\VariableWidthFont.asm
armips.exe asm\SmallVWF.asm
armips.exe asm\FixStatsMenu.asm
ren rom\output.gba speed_patched.gba
Atlas rom\speed_patched.gba script\tf2_bootleg_script_autowrite.txt
pause