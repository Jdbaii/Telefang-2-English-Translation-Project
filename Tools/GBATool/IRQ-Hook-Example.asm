;-------------------------------------------->
; Game: Lady Sia / US -+- MODE7 Release
;<--------------------------------------------
; GBA-Tool Hook-Inject
; <c>opyright by [NtSC] -+- 2001/2002
;-------------------------------------------->

  CODE16
  AREA Trainerhook, CODE, READONLY

  ENTRY
start
	push	{r1-r2}
	ldr		r2,optionram
	ldrb	r1,[r2]				
	cmp		r1,#1				
	bne		option2			
;--------------------------------------------------------------
  ldr    r0,Lives				;Lifes
      mov    r1,#3
      strb   r1,[r0]
;--------------------------------------------------------------
option2
	add		r2,r2,#1				
      ldrb	r1,[r2]						
	cmp		r1,#1						
	bne		option3					

  ldr    r0,Energy				;Energy
      mov    r1,#5
      strb   r1,[r0]
;--------------------------------------------------------------
option3
	add		r2,r2,#1					
	ldrb	r1,[r2]						
	cmp		r1,#1							
	bne		option4						

  ldr    r0,Magic				;Magic
      mov    r1,#25
      strb   r1,[r0]
;--------------------------------------------------------------
option4
	add		r2,r2,#1					
	ldrb	r1,[r2]						
	cmp		r1,#1							
	bne		option5

  ldr    r0,Items				;Items
      mov    r1,#3
      strb   r1,[r0]
;--------------------------------------------------------------
option5
	add		r2,r2,#1					
	ldrb	r1,[r2]						
	cmp		r1,#1						
	bne		nokey						

  ldr	   r2, keyreg
 	ldrb		r1, [r2]
	mov		r2, #0x04
 	ands		r1, r2
 	bne		nokey

  ldr    r0,Time				;Time
      mov    r1,#00
      strb   r1,[r0]
  ldr    r0,Time0				;Time
      mov    r1,#00
      strb   r1,[r0]
  ldr    r0,Time1				;Time
      mov    r1,#00
      strb   r1,[r0]
  ldr    r0,Time2				;Time
      mov    r1,#00
      strb   r1,[r0]

;--------------------------------------------------------------
nokey
	pop		{r1-r2}
  adr		r0,armstart
  bx		r0								

	CODE32

armstart
	ldr		r0,jumpback
	bx		r0								
ALIGN

;==================> Options <====================
Energy
  DCD 0x03001e08
Lives
  DCD 0x03001de0
Magic
  DCD 0x03001d58
Time
  DCD 0x03001dec
Items
  DCD 0x03001d2c
Time0
  DCD 0x03001ded
Time1
  DCD 0x03001dee
Time2
  DCD 0x03001def
;=================================================
optionram
  DCD 0x03007fc0
;=================================================
keyreg
  DCD 0x04000130
;-------------------------------------------------------------------------
jumpback
  DCD 0x08001a35                        ; IRQ-Table Entry we wanna hook 
  DCD 0x0802def1                        ; our Hook-Adress +4
  DCD 0x0802def1                        ; our Hook-Adress +8
ToolSign
  DCB "[EOH]"                           ; Hook-Signature for the Tool
;-------------------------------------------------------------------------
  END
