@echo off
echo Deleting patched ROMs...
del rom\power_patched.gba
copy rom\power_2009trans.gba rom\power_patched.gba
echo Compressing smallMenuGfx...
Tools\GfxCompressor.exe asm\bin\SmallMenuGfx.bin asm\bin\SmallMenuGfx_Malias2.bin
call batchcompressgfx.bat
echo Applying ASM hacks...
armips.exe asm\GFX.asm
armips.exe asm\VariableWidthFont_Power.asm
echo Inserting script...
Atlas rom\power_patched.gba script\tf2_bootleg_script_autowrite.txt
echo Done.
pause