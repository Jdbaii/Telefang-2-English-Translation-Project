;<--------------------------------------------
; GBA-Tool Hook-Inject
; <C>opyright by [NtSC] -+- 2001/2002
;-------------------------------------------->
  CODE16
  AREA Trainerhook, CODE, READONLY

  ENTRY
start
	push	{r0-r2}

	ldr		r2,optionram
	ldrb	r1,[r2]				
	cmp		r1,#1				
	bne		nokey			

 ldr    r0,Energy
      mov    r1,#0x08c
      strb   r1,[r0]
      strb   r1,[r0, #2]
;--------------------------------------------------------------
nokey
	pop		{r0-r2}
      ldr	       r0, keyreg          ; This Stuff was taken from GBA-Tool    
      ldrh          r1, [r0]            ; Hunt-Keyloop Function :>
	ldr		r2,jumpback0
	bx		r2								
 
	ALIGN 
;==================> Options <====================
optionram
  DCD 0x03007f00
;=================================================
keyreg
  DCD 0x04000130
;=================================================
Energy
  DCD 0x030047a2
;-------------------------------------------------------------------------
jumpback0
  DCD 0x0800089d                        ; TrainerHook-Return-Adress
jumpback
  DCD 0x04000130                        ; Value to Patch with Hook-Adress
  DCD 0x000003ff                        ; Security-Check Value #1 
  DCD 0x0000FFDF                        ; Security-Check-Value #2 
ToolSign
  DCB "[EOH]"                           ; Hook-Signature for the Tool
;-------------------------------------------------------------------------
  END
