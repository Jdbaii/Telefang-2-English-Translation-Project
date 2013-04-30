@echo off
echo Deleting patched ROMs...
del rom\power_patched.gba
copy rom\power_2009trans.gba rom\power_patched.gba
call batchcompressgfx.bat
echo Applying ASM hacks...
armips.exe asm\GFX.asm
armips.exe asm\VariableWidthFont_Power.asm
armips.exe asm\Intro8bpp.asm
echo Inserting script...
Atlas rom\power_patched.gba script\tf2_bootleg_script_autowrite.txt
echo Done.
pause