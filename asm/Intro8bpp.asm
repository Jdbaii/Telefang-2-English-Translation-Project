 ; Telefang 2 Power Intro Hack by Jdbye
 ; Purpose: Adds an intro to the ROM

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
.arm
.org 0x8000000
b main

.org 0x8870000
main:
	mov r0, #0x400
	add r0, r0, #4
	mov r1, #0x4000000
	strh r0, [r1]
	
	ldr r1,=splashScreen
	mov r0, #0x5000000   ; small loop to load the palette
	mov r2, #128
loop1:
	ldr r3,[r1],#4
	str r3,[r0],#4
	subs r2, r2, #1
	bne loop1

	mov r0, #0x6000000  ; address of VRAM
	mov r2, #0x4B0     ; the amount of 32 BYTE writes to fill the screen (we'll be using a new instruction)
loop2:
	ldmia r1!, r3,r4,r5,r6,r7,r8,r9,r10  ; will start with the address in r1, it will load each listed register
				; with 32bits from memory, incrementing the address by 4 each time. The final address used +4
				; will be written back into r1 (because of the !). Note this instruction doesn't use 
				; brackets around the register used for the address.
	stmia r0!, r3,r4,r5,r6,r7,r8,r9,r10  ; will start with the address in r1, it will store each listed register
				; into memory (32bit write), adding 4 to the address. The final address used +4 will
				; be written back.
	; These instructions are a fast(er) way to do block memory copying, they are only useful when you have alot of
	; registers available (registers 3-10 were used here, but I could have said r2,r4, they don't have to be in order
	; just don't use the address register in the destination list.

	subs r2, r2, #1  ; subtraction setting the flags
	bne loop2  ; will loop if r2 wasn't zero.
infin:
;mov lr, pc ;need to add 8+1 on later
ldr r0, =CheckKeys ; my notes say this is free
bx r0
CheckKeys:
ldr r0, =0x4000130
ldrh r0, [r0]
;mov r1, #0xA3FE ;A+B+L+R
ldr r1, [buttons]
cmp r0, r1
beq 0x80000C0 ; jump to original code when A pressed
b infin ; infinite loop
; .ltorg ; give the assembler a place to put the immediate value "pool", needed for the ldr REG,= (s). pic:
; a label to indicate the address of the included data.
.align 4
.align 4
buttons:
	.word 0x000003FE
	
.pool
splashScreen:
.incbin "asm/bin/splashScreen8bpp.bin" ; include the binary file
