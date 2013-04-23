 ; Telefang 2 Speed 8x8 font hack by Spikeman
 ; Ported to Power by Jdbye

.gba				; Set the architecture to GBA
.open "rom/output.gba",0x08000000		; Open input.gba for output.
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

.org 0x8136A0E ; routine that puts a character to the map
    ldr r2, =putChar+1    ; r2 is best variable to use for jump
    bx r2
    
.pool
    
.org 0x8136A22
    nop         ; stop tile incrementing on its own
    
.org 0x8136A2E
    ldr r3, =endString+1
    bx r3
.pool
    
.org 0x87f3b00 ; should be free space to put code (might change if other VWF routine is extended)
putChar:
    ; r1 is the character to be drawn
    ; this routine prints the character to vram and returns the correct tile
    ; the game stores the returned value in the proper place in the tilemap


    ldr r2,[tileCount]
    push r2-r7
    mov r3,r2
    ldr r2,=smallFont
    ldrb r4,[r3]    ; r4 = tile count
    ldr r5,=widthTable
    ldrb r5,[r5,r1] ; get width
    mov r0,0x20
    mul r1,r0
    add r1,r1,r2    ; r1 is address of char in ROM
    mul r0,r4       ; r0 = VRAM offset
    ldr r2,[freeVRAM]
    add r2,r2,r0    ; r2 = VRAM address, r0 is free
    
    ;mov r5,#5       ; width table lookup will go here
    ldrb r7,[r3,#1] ; get overflow
    add r0,r7,r5
    cmp r0,#8
    ble NoOverflow  ; blt NoOverflow - this messed up when characters were 8 wide
    mov r6,#8
    sub r0,r0,r6
    add r4,r4,#1    ; increment tile count
    strb r4,[r3]
    ldr r4,[sp,#0x0c] ; increment tilemap address
    add r4,r4,#2
    str r4,[sp,#0x0c]
NoOverflow:
    strb r0,[r3,#1]
    
    lsl r0,r7,2     ;r0 = shift amount (<<2 because 4bpp)
    mov r4,#0x20
    add r3,r2,r4    ; r3 = overflow tile addr (this is kind of out of place, but it's a nice optimization)
    sub r4,r4,r0    ;r4 = background shift amount
    
    mov r5,#0       ; copy font data to vram
putLoop:
    ldr r6,[r1,r5]
    ldr r7,[r2,r5]
    lsl r6,r0
    lsl r7,r4
    lsr r7,r4
    orr r6,r7
    str r6,[r2,r5]
    
    ldr r6,[r1,r5]
    ldr r7,[r3,r5]
    lsr r6,r4
    lsr r7,r0
    lsl r7,r0
    orr r6,r7
    str r6,[r3,r5]
    
    add r5,r5,#4
    cmp r5,#0x20
    blt putLoop
    
    pop r2-r7
    ldrb r1,[r2]    ; r1 is tile number, original code will add 0x200
    ;add r1,r1,#1
    ;strb r1,[r3]    ; this will make it start on the second tile, so the background can use the space
   
   
    mov r0,#0x80    ; overwritten code
    lsl r0,r0,#2
    add r1,r1,r0    ; r1 = char value
    and r1,r6       ; r1 = final tile value
    ldrh r2,[r3]    ; r2 = last attrib value - used to get palette

    ldr r0, [returnAddr]    ; r0 overwritten upon return
    bx r0
    
.align 4
returnAddr: .word 0x08136A18+1   ;.word 0x81369FC+1
tileCount:  .word 0x03000000     ; surprisingly this WRAM is usable, 03000001 will be overflow
freeVRAM:   .word 0x06008000     ; VRAM to load tiles into  (0x0600C000 is extra but wont work because bg base)
.pool

; replace the end of the string printing routine so we can reset the overflow to zero
; also increment the tile counter so each string starts on a fresh tile
endString:
    mov r3,#3
    lsl r3,r3,#0x18 ;set r3 to 0x03000000
    ldrb r4,[r3]
    add r4,r4,#1
    strb r4,[r3]
    mov r4, #0
    strb r4,[r3,#1]

    ;original code, don't bother jumping back, just end the routine
    add sp,#4
    pop r3,r4
    mov r8,r3
    mov r9,r4
    pop r4-r7
    pop r0
    bx r0

.org 0x87FE850 ; note this extends past the end of the rom, this will overwrite menu gfx if nofont version isnt used
smallFont:
.incbin asm/bin/smallFont_vwf.bin   ;smallFont.bin
widthTable:
.incbin asm/bin/smallWidthTable.bin

.close

 ; make sure to leave an empty line at the end
