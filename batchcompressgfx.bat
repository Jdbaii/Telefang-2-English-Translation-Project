@echo off
for %%A IN (asm\bin\GFX\*_Malias2.bin) do del %%A
for %%A IN (asm\bin\GFX\*.bin) do echo Compressing %%~nA%%~xA && Tools\GfxCompressor.exe asm\bin\GFX\%%~nA%%~xA asm\bin\GFX\%%~nA_Malias2%%~xA
pause