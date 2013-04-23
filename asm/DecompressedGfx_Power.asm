 ; Telefang 2 Speed Compressed Graphics Hack written by Normmatt
 ; Ported to Power by Jdbye

.gba				; Set the architecture to GBA
.open "rom/power_patched.gba",0x08000000		; Open input.gba for output.
					; 0x08000000 will be used as the
					; header size
					
.macro adr,destReg,Address
here:
	.if (here & 2) != 0
		add destReg, r15, (Address-here)-2
	.else
		add destReg, r15, (Address-here)
	.endif
.endmacro

.org 0x0813FDAC
.area 0x0813FE38-0x0813FDAC
.thumb
.definelabel decompressGFX,0x0811E59C
setupMenuGFX:
	push    {r4,r5,lr}      ; decompress and load ingame menu gfx
	ldr     r0, =smallMenuGfx_LZ77 ;ldr r0, =0x852e9e4
	ldr     r5, =0x6007C00 ;ldr r5, =0x6004000
	lsr     r1, r5, #0xc ;adds    r1, r5, #0
	lsl     r1, r1, #0xc
	swi     0x12 ;bl      decompressGFX   ; smaller menu options gfx
	ldr     r1, =0x8501228
	ldr     r4, =0x3004cf0
	mov     r0, #0xb7
	lsl     r0, r0, #2
	add     r4, r4, r0
	ldrb    r0, [r4]
	lsl     r0, r0, #2
	add     r0, r0, r1
	ldr     r0, [r0]
	ldr     r1, =0x6004000 ;adds    r1, r5, #0
	bl      decompressGFX   ; phone gfx
	ldr     r0, =0x85316bc
	ldr     r5, =0x3000860
	add     r1, r5, #0
	bl      decompressGFX   ; background gfx
	ldr     r1, =0x40000d4
	ldrb    r0, [r4]
	lsl     r0, r0, #7
	add     r0, r0, r5
	str     r0, [r1]
	ldr     r0, =0x6007c00
	str     r0, [r1,#4]
	ldr     r0, =0x84000020
	str     r0, [r1,#8]
	ldr     r0, [r1,#8]
	ldr     r2, =0x8501244
	ldrb    r0, [r4]
	lsl     r0, r0, #2
	add     r0, r0, r2
	ldr     r0, [r0]
	str     r0, [r1]
	mov     r0, #0xa0
	lsl     r0, r0, #0x13
	str     r0, [r1,#4]
	ldr     r0, =0x80000010
	str     r0, [r1,#8]
	ldr     r0, [r1,#8]
	pop     {r4,r5}
	pop     {r0}
	bx      r0
; End of function setupMenuGFX
.pool
.endarea

.org 0x87FD000
smallMenuGfx_LZ77:
;.incbin asm/bin/smallMenuGfx_nofont_LZ77.bin
.incbin asm/bin/smallMenuGfx.bin.compressed

.close

 ; make sure to leave an empty line at the end
