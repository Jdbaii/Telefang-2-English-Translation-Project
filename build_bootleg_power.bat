del rom\power_patched.gba
copy rom\power_2009trans.gba rom\power_patched.gba
Tools\GfxCompressor.exe asm\bin\SmallMenuGfx.bin asm\bin\SmallMenuGfx_Malias2.bin
armips.exe asm\GFX.asm
armips.exe asm\VariableWidthFont_Power.asm
Atlas rom\power_patched.gba script\tf2_bootleg_script_autowrite.txt
pause