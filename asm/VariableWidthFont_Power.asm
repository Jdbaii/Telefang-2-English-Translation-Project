     ; Telefang 2 Power/Speed - Variable Width Font Hack
     ; by Spikeman based on HWF code by Normmatt
     
    .gba                            ; Set the architecture to GBA
    .open "rom/power_patched.gba",0x08000000               ; Open input.gba for output.
                                            ; 0x08000000 will be used as the
                                            ; header size
                                           
    ;.macro adr,destReg,Address
    ;here:
    ;       .if (here & 2) != 0
    ;               add destReg, r15, (Address-here)-2
    ;       .else
    ;               add destReg, r15, (Address-here)
    ;       .endif
    ;.endmacro
    .macro adr,destReg,Address
    here:
            .if (here & 2) != 0
                    add destReg, r15, (Address-here)-6
            .else
                    add destReg, r15, (Address-here)-4
            .endif
    .endmacro
     
    .ifdef SPEED
    .org 0x08129B00
    .else
    .org 0x08129D00
    .endif
     ; Set overflow flag to 1 to indent the first characters by 1px
    .thumb
            ldr r0, =newTextbox+1
            bx r0
     
    .pool
     
    .ifdef SPEED
    .org 0x08129F24
    .else
    .org 0x0812A124
    .endif
    .thumb
     ; Extend the number of characters per line
            ;cmp r0, #0x18 ;cmp r0, #0x0F
            ;bhi 0x08129f30
            ;mov r0, #0x19 ;movs r0, #0x10
        ldr r0, =newline+1
            bx r0
    .pool
     
    .ifdef SPEED
    .org 0x0812A036
    .else
    .org 0x0812A236
    .endif
     
    .thumb
     
     ; Modify the IsRedControlCode function to jump to my address calculation code
            ldr r0, =calculate_address+1
            bx r0
     
    .pool
     
    .ifdef SPEED
    .org 0x0812A068
    .else
    .org 0x0812A268
    .endif
    .thumb
        nop     ; get rid of the original tile increment code
     
    .ifdef SPEED
    .org 0x0812A07E
    .else
    .org 0x0812A27E
    .endif
     
    .thumb
     ;Parse in maximum of 0x2F characters
            cmp r0, #0x2F ;cmp r0, #0x1E
           
    .ifdef SPEED
    .org 0x0812A652
    .else
    .org 0x0812A852
    .endif
     ;Always use DMA/MyCode to draw main font
     ;this means no Red highlighting atleast for now
            cmp r2,r2 ;cmp r2, #0
           
    .ifdef SPEED
    .org 0x0812A6EC
    .else
    .org 0x0812A8EC
    .endif
     ;Replace original DMA code with my own
            ldr r4, =(PrintColoredCharDMA+1)
            bx r4
    .pool
     
    .ifdef SPEED
    .org 0x081C5B10
    .else
    .org 0x081C5E1C
    .endif
    .incbin asm/bin/textBox_spritePositions.bin
     
    .ifdef SPEED
    .org 0x08740950
    .else
    .org 0x08740C78
    .endif
    .incbin asm/bin/oldFont.bin
     
    .org 0x087F3A00
    .thumb
     
     ;r2 - color
    PrintColoredCharDMA:
            mov r4,r5       ; r4 = overflow tile
            cmp r2, #0
            beq PrintColoredCharDMA_Blue
            ldr r1, =BlueFont
            b PrintColoredCharDMA_continue
    PrintColoredCharDMA_Blue:
            ldr r1, =BlueFont
           
    PrintColoredCharDMA_continue:
            ;mov r2, #5     ; r2 = width, replace this with lookup table using r0
            ldr r2, =WidthTable
            ldrb r2, [r2,r0]
     
            lsl r0, r0, #6
            add r0, r0, r1  ; r0 = address of font character
     
            ldr r6, [overflow]
            ldrb r1, [r6]
            mov r5, r1      ; r5 = current overflow
            add r1, r1, r2  ; r1 will be new overflow, r2 is spare after this
            cmp r1, #8
            blt NoNewTile   ; if overflow >8 move to next tile
        mov r2, #8
            sub r1, r1, r2
            ;ldr r7, [tilepos]   ;increment character position
        ;ldrb r2, [r7]
        ldrb r2, [r6, #0xC]
        add r2,r2,#1
        ;strb r2, [r7]
        strb r2, [r6, #0xC]
    NoNewTile:
            strb r1, [r6]
     
            lsl r5, r5, 2   ; *4, for 4bpp
            mov r6, #0x20   ; i feel like this code should be somewhere else
            sub r6, r6, r5  ; r6 is to shift the existing background
     
            ;r0 = font, r3 = VRAM, r4 = overflow tile, r5 will be shift
     
            bl PrintHalfChar
     
            mov r1, #0x20
            add r0, r0, r1  ; r0 = next half of char
            lsl r1, r1, #1  ; add 0x40 to vram to skip a tile
            add r3, r3, r1
            add r4, r4, r1
     
            bl PrintHalfChar
     
    PrintColoredCharDMA_return:
            pop {r3,r4}
            mov r8, r3
            mov r9, r4
            pop {r4-r7}
            pop {r0}
            bx r0
     
     
    PrintHalfChar:
            mov r7, 0       ; r7 = loop counter
     
    PrintHalfChar_loop:
            ldr r1, [r0,r7] ; r0 = character data
            ldr r2, [r3,r7]
            lsl r1,r5
            lsl r2,r6       ; shift out part of background to be overwritten
            lsr r2,r6      
            orr r1,r2
            str r1, [r3,r7]
     
            ldr r1, [r0,r7] ; now do overflow tile
            ldr r2, [r4,r7]
            lsr r1,r6       ; swap shifts (i think this will work)
            lsr r2,r5
            lsl r2,r5      
            orr r1,r2
            str r1, [r4,r7]
     
            add r7,r7,4     ; each row = 4 bytes
            cmp r7, #0x20   ; are 8 rows printed?
            bne PrintHalfChar_loop
            bx r14
     
    .align 4
    .pool
    overflow:  
    .ifdef SPEED
            .word 0x3005100  ; my notes say this is free    ;0x2FF0000      ;this ram should be fine to use
    .else
            .word 0x3005110  ; my notes say this is free    ;0x2FF0000      ;this ram should be fine to use
    .endif
     
     ; New textbox
    newTextbox:
            str r7, [r1,#4]                 ; original code
            ldr r0, [dmaSet]                ; original code
            str r0, [r1,#8]                 ; original code
            ldr r0, [r1,#8]                 ; original code
           
            mov r0, #1              ; reset overflow
        strb r0, [r7, #0x10]    ; r7+0x10 = overflow
           
            ldr r0, [ntb_returnAdr]
            bx r0
           
     
    dmaSet:                 .word 0x85000008       
    ntb_returnAdr: 
    .ifdef SPEED
            .word 0x08129B09
    .else
            .word 0x08129D09
    .endif 
     
     ; New newline
    newline:
        mov r0, #1              ; reset overflow
        strb r0, [r7, #0x10]    ; r7+0x10 = overflow
     
        ;original routine
        ldrb r0, [r7, #0x1C]
        cmp r0, #0x19
        bhi newline_
        mov r0, #0x1A
        strb r0, [r7, #0x1C]
            ldr r0, [nl_returnAdr]  
            bx r0
    newline_:
        mov r0, #2
        strb r0,[r7,#4] ; copy of opcode at 0812A028 so i can use r0
        ldr r0, [nl_returnAdr2]  
            bx r0
     
    .align 4
    nl_returnAdr:  
    .ifdef SPEED
            .word 0x0812A0A1 ; last instruction that was overwritten was b 812A0A0
    .else
            .word 0x0812A2A1 ; last instruction that was overwritten was b 812A0A0
    .endif
    nl_returnAdr2: 
    .ifdef SPEED
            .word 0x0812A02B
    .else
            .word 0x0812A22B
    .endif
     
     
     ;Text position calculation function
    ;.org 0x087f4000
     
    ;r0 - character number
    ;r1 - vram index base
     
    .thumb
    calculate_address:
            mov r0,r2
            add r5,r0,1     ;r5 SHOULD be free, if things break this is why
            adr r2, lookup_table
            lsl r0,r0,#1
            lsl r5,r5,#1
            ;add r2,r2,r0
            ldrh r0, [r2,r0]        ;was ldrh r0, [r2]
            ldrh r5, [r2,r5]
           
            ;original code
            ;ldr r2, [vram]
            ;add r0,r0,r2
            ;add r1,r1,r0   ;r1 = 0x6000
            ldr r2, [vram]
            add r2,r2,r1    ;r2 = 0x6016000
            add r1,r0,r2
            add r5,r5,r2    ;return r1 AND r5
     
            ldr r2, [returnAdr]
            bx r2
     
    .align 4
    returnAdr:
    .ifdef SPEED
            .word 0x0812a049        ;0x0812a043
    .else
            .word 0x0812a249        ;0x0812a243
    .endif
    vram:
            .word 0x06010000
    lookup_table:
            .halfword 0x0000                ; 0
            .halfword 0x0020                ; 1
            .halfword 0x0100                ; 2
            .halfword 0x0120                ; 3
            .halfword 0x0200                ; 4
            .halfword 0x0220                ; 5
            .halfword 0x0300                ; 6
            .halfword 0x0320                ; 7
            .halfword 0x0400                ; 8
            .halfword 0x0420                ; 9
            .halfword 0x0500                ; 10
            .halfword 0x0520                ; 11
            .halfword 0x0600                ; 12
            .halfword 0x0620                ; 13
            .halfword 0x0700                ; 14
            .halfword 0x0720                ; 15
            .halfword 0x0800                ; 16
            .halfword 0x0820                ; 17
            .halfword 0x0900                ; 18
            .halfword 0x0920                ; 19
            .halfword 0x0A00                ; 20
            .halfword 0x0A20                ; 21
            .halfword 0x0B00                ; 22
            .halfword 0x0B20                ; 23
            .halfword 0x0F00                ; 24
            .halfword 0x0F20                ; 25
            .halfword 0x0080                ; 26
            .halfword 0x00A0                ; 27
            .halfword 0x0180                ; 28
            .halfword 0x01A0                ; 29
            .halfword 0x0280                ; 30
            .halfword 0x02A0                ; 31
            .halfword 0x0380                ; 32
            .halfword 0x03A0                ; 33
            .halfword 0x0480                ; 34
            .halfword 0x04A0                ; 35
            .halfword 0x0580                ; 36
            .halfword 0x05A0                ; 37
            .halfword 0x0680                ; 38
            .halfword 0x06A0                ; 39
            .halfword 0x0780                ; 40
            .halfword 0x07A0                ; 41
            .halfword 0x0880                ; 42
            .halfword 0x08A0                ; 43
            .halfword 0x0980                ; 44
            .halfword 0x09A0                ; 45
            .halfword 0x0A80                ; 46
            .halfword 0x0AA0                ; 47
            .halfword 0x0B80                ; 48
            .halfword 0x0BA0                ; 49
     
    ;.org 0x087F5000
    .align 4
    BlueFont:
    .incbin asm/bin/BlueFont.bin
    .align 4
    RedFont:
    .incbin asm/bin/RedFont.bin
    .align 4
    WidthTable:
    .incbin asm/bin/WidthTable.bin
     
    .close
     
     ; make sure to leave an empty line at the end
