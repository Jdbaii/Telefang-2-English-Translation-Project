 ; Telefang 2 Power Graphics Replacement Hack by Jdbye
 ; Purpose: Adds binaries to file and changes pointers to match

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

.thumb
; Misc menu graphics
.org 0x81357B0
    .word smallMenuGfx
.org 0x813599C
    .word smallMenuGfx
.org 0x813FE0C
    .word smallMenuGfx
.org 0x81430CC
    .word smallMenuGfx
.org 0x8143FF0
    .word smallMenuGfx
.org 0x8160130
    .word smallMenuGfx
	
; Battle font
.org 0x8110D14
	.word battleFont
.org 0x81173FC
	.word battleFont
.org 0x8138A28
	.word battleFont
.org 0x8145628
	.word battleFont
.org 0x814F728
	.word battleFont
.org 0x8166074
	.word battleFont
	
; Large font (for denjuu names etc)
.org 0x8134188
	.word bigFont
.org 0x81389E8
	.word bigFont
	
; D-Shot font
.org 0x8155C04
	.word DShotFont
.org 0x8155C34
	.word DShotFont
.org 0x8155D18
	.word DShotFont
.org 0x8155D80
	.word DShotFont
.org 0x8157638
	.word DShotFont
.org 0x8157688
	.word DShotFont
.org 0x815BDEC
	.word DShotFont
.org 0x815BF1C
	.word DShotFont
.org 0x815BFFC
	.word DShotFont
	
; D-Shot Graphics
.org 0x81570F4
	.word DShotGfx
	
; Stats Screen Tile Maps
.org 0x81360D4
	.word statsTileMap
	
.org 0x81360DC
	.word statsTileMap2
	
; Dex Tile Map
.org 0x8139DA8
	.word dexTileMap
	
; Title Screen Gfx
; Disabled at the moment
; .org 0x81663A0
; 	.word titleScreenGfx
; .org 0x8167B58
; 	.word titleScreenGfx
	
.org 0x8503F9C
	.word titleScreenLogo
	
.org 0x8503FA0
	.word titleScreenLogoTileMap
	
.org 0x8503FA8
	.word titleScreenLogoOutline
	
.org 0x8503FAC
	.word titleScreenLogoOutlineTileMap
	
.org 0x87C1DF4
	.word 0x00000000 ; Corrupt the old logo outline graphic
	.word 0x00000000 ; Corrupt the old logo outline graphic
	.word 0x00000000 ; Corrupt the old logo outline graphic
	.word 0x00000000 ; Corrupt the old logo outline graphic
	.word 0x00000000 ; Corrupt the old logo outline graphic
	
; -------------------------------------
.org 0x81359AC
	.word gfx126
.org 0x8137E58
	.word gfx126
.org 0x8141AC4
	.word gfx126
.org 0x8141D74
	.word gfx126
.org 0x8142920
	.word gfx126
.org 0x8143238
	.word gfx126
.org 0x816086C
	.word gfx126
.org 0x8161550
	.word gfx126
	
; -------------------------------------
.org 0x8136758
	.word gfx127
	
; -------------------------------------
.org 0x8139610
	.word gfx128
.org 0x8143FFC
	.word gfx128
	
; -------------------------------------
.org 0x8500D2C
	.word gfx132
	
; -------------------------------------
.org 0x8500D30
	.word gfx133
	
; -------------------------------------
.org 0x8500D34
	.word gfx134
	
; -------------------------------------
.org 0x8500D38
	.word gfx135
	
; -------------------------------------
.org 0x8500D3C
	.word gfx136
	
; -------------------------------------
.org 0x8500D40
	.word gfx137
	
; -------------------------------------
.org 0x8500D44
	.word gfx138
	
; -------------------------------------
.org 0x8500D48
	.word gfx139
	
; -------------------------------------
.org 0x8500D4C
	.word gfx140
	
; -------------------------------------
.org 0x8500D50
	.word gfx141
	
; -------------------------------------
.org 0x8500D54
	.word gfx142
	
; -------------------------------------
.org 0x8500D58
	.word gfx143
	
; -------------------------------------
.org 0x8500D5C
	.word gfx144
		
; -------------------------------------
.org 0x8500D60
	.word gfx145
	
; -------------------------------------
.org 0x8500D64
	.word gfx146
	
; -------------------------------------
.org 0x8500D68
	.word gfx147
	
; -------------------------------------
.org 0x8500D6C
	.word gfx148
	
; -------------------------------------
.org 0x8500D70
	.word gfx149
	
; -------------------------------------
.org 0x8500D74
	.word gfx150
	
; -------------------------------------
.org 0x8500D78
	.word gfx151
	
; -------------------------------------
.org 0x8500D7C
	.word gfx152
	
; -------------------------------------
.org 0x8500D80
	.word gfx153
	
; -------------------------------------
.org 0x8500D84
	.word gfx154
	
; -------------------------------------
.org 0x8500D88
	.word gfx155
	
; -------------------------------------
.org 0x8500D8C
	.word gfx156
	
; -------------------------------------
.org 0x8500D90
	.word gfx157
	
; -------------------------------------
.org 0x8500D94
	.word gfx158
	
; -------------------------------------
.org 0x8500D98
	.word gfx159
	
; -------------------------------------
.org 0x8500D9C
	.word gfx160
	
; -------------------------------------
.org 0x8500DA0
	.word gfx161
	
; -------------------------------------
.org 0x8500DA4
	.word gfx162
	
; -------------------------------------
.org 0x8500DA8
	.word gfx163
	
; -------------------------------------
.org 0x8500DB4
	.word gfx166
	
; -------------------------------------
.org 0x8500DB8
	.word gfx167
	
; -------------------------------------
.org 0x8500DBC
	.word gfx168
	
; -------------------------------------
.org 0x8500DC0
	.word gfx169
	
; -------------------------------------
.org 0x8500E20
	.word gfx193
	
; -------------------------------------
.org 0x8500E24
	.word gfx194
	
; -------------------------------------
.org 0x8500E28
	.word gfx195
	
; -------------------------------------
.org 0x8500E2C
	.word gfx196
	
; -------------------------------------
.org 0x8500E30
	.word gfx197
	
; -------------------------------------
.org 0x8500E34
	.word gfx198
	
; -------------------------------------
.org 0x8500E38
	.word gfx199
	
; -------------------------------------
.org 0x8500E3C
	.word gfx200
	
; -------------------------------------
.org 0x8500E40
	.word gfx201
	
; -------------------------------------
.org 0x8500E44
	.word gfx202
	
; -------------------------------------
.org 0x8500E48
	.word gfx203
	
; -------------------------------------
.org 0x8500E4C
	.word gfx204
	
; -------------------------------------
.org 0x8500E50
	.word gfx205
	
; -------------------------------------
.org 0x8500E54
	.word gfx206
	
; -------------------------------------
.org 0x8500E58
	.word gfx207
	
; -------------------------------------
.org 0x8500E5C
	.word gfx208
	
; -------------------------------------
.org 0x8500E60
	.word gfx209
	
; -------------------------------------
.org 0x8500E64
	.word gfx210
	
; -------------------------------------
.org 0x8500E68
	.word gfx211
	
; -------------------------------------
.org 0x8500E6C
	.word gfx212
	
; -------------------------------------
.org 0x8500E70
	.word gfx213
	
; -------------------------------------
.org 0x8500E7C
	.word gfx216
	
; -------------------------------------
.org 0x8500E80
	.word gfx217
	
; -------------------------------------
.org 0x8128C6C
	.word gfx2753
	
; -------------------------------------
.org 0x8128C74
	.word gfx2754
	
; -------------------------------------
.org 0x81584C8
	.word gfx2761
.org 0x8158E8C
	.word gfx2761
	
.org 0x8890000

.align 4
battleFont:
.incbin asm/bin/battleFont.bin

.align 4
bigFont:
.incbin asm/bin/bigFont.bin

.align 4
DShotFont:
.incbin asm/bin/DShotFont.bin

.align 4
DShotGfx:
.incbin asm/bin/DShotGfx.bin

.align 4
smallMenuGfx:
.incbin asm/bin/gfx/smallMenuGfx_Malias2.bin

.align 4
statsTileMap:
.incbin asm/bin/gfx/statsTileMap_Malias2.bin

.align 4
statsTileMap2:
.incbin asm/bin/gfx/statsTileMap2_Malias2.bin

.align 4
dexTileMap:
.incbin asm/bin/gfx/dexTileMap_Malias2.bin

.align 4
titleScreenGfx:
.incbin asm/bin/gfx/titleScreenGfx_Malias2.bin

.align 4
titleScreenLogo:
.incbin asm/bin/gfx/logo_english.img_Malias2.bin

.align 4
titleScreenLogoOutline:
.incbin asm/bin/gfx/logo_outline_english.img_Malias2.bin

.align 4
titleScreenLogoTileMap:
.incbin asm/bin/gfx/logo_english.map_Malias2.bin

.align 4
titleScreenLogoOutlineTileMap:
.incbin asm/bin/gfx/logo_outline_english.map_Malias2.bin

.align 4
gfx126:
.incbin asm/bin/GFX/126_Malias2.bin

.align 4
gfx127:
.incbin asm/bin/GFX/127_Malias2.bin

.align 4
gfx128:
.incbin asm/bin/GFX/128_Malias2.bin

.align 4
gfx132:
.incbin asm/bin/GFX/132_Malias2.bin

.align 4
gfx133:
.incbin asm/bin/GFX/133_Malias2.bin

.align 4
gfx134:
.incbin asm/bin/GFX/134_Malias2.bin

.align 4
gfx135:
.incbin asm/bin/GFX/135_Malias2.bin

.align 4
gfx136:
.incbin asm/bin/GFX/136_Malias2.bin

.align 4
gfx137:
.incbin asm/bin/GFX/137_Malias2.bin

.align 4
gfx138:
.incbin asm/bin/GFX/138_Malias2.bin

.align 4
gfx139:
.incbin asm/bin/GFX/139_Malias2.bin

.align 4
gfx140:
.incbin asm/bin/GFX/140_Malias2.bin

.align 4
gfx141:
.incbin asm/bin/GFX/141_Malias2.bin

.align 4
gfx142:
.incbin asm/bin/GFX/142_Malias2.bin

.align 4
gfx143:
.incbin asm/bin/GFX/143_Malias2.bin

.align 4
gfx144:
.incbin asm/bin/GFX/144_Malias2.bin

.align 4
gfx145:
.incbin asm/bin/GFX/145_Malias2.bin

.align 4
gfx146:
.incbin asm/bin/GFX/146_Malias2.bin

.align 4
gfx147:
.incbin asm/bin/GFX/147_Malias2.bin

.align 4
gfx148:
.incbin asm/bin/GFX/148_Malias2.bin

.align 4
gfx149:
.incbin asm/bin/GFX/149_Malias2.bin

.align 4
gfx150:
.incbin asm/bin/GFX/150_Malias2.bin

.align 4
gfx151:
.incbin asm/bin/GFX/151_Malias2.bin

.align 4
gfx152:
.incbin asm/bin/GFX/152_Malias2.bin

.align 4
gfx153:
.incbin asm/bin/GFX/153_Malias2.bin

.align 4
gfx154:
.incbin asm/bin/GFX/154_Malias2.bin

.align 4
gfx155:
.incbin asm/bin/GFX/155_Malias2.bin

.align 4
gfx156:
.incbin asm/bin/GFX/156_Malias2.bin

.align 4
gfx157:
.incbin asm/bin/GFX/157_Malias2.bin

.align 4
gfx158:
.incbin asm/bin/GFX/158_Malias2.bin

.align 4
gfx159:
.incbin asm/bin/GFX/159_Malias2.bin

.align 4
gfx160:
.incbin asm/bin/GFX/160_Malias2.bin

.align 4
gfx161:
.incbin asm/bin/GFX/161_Malias2.bin

.align 4
gfx162:
.incbin asm/bin/GFX/162_Malias2.bin

.align 4
gfx163:
.incbin asm/bin/GFX/163_Malias2.bin

.align 4
gfx166:
.incbin asm/bin/GFX/166_Malias2.bin

.align 4
gfx167:
.incbin asm/bin/GFX/167_Malias2.bin

.align 4
gfx168:
.incbin asm/bin/GFX/168_Malias2.bin

.align 4
gfx169:
.incbin asm/bin/GFX/169_Malias2.bin

.align 4
gfx193:
.incbin asm/bin/GFX/193_Malias2.bin

.align 4
gfx194:
.incbin asm/bin/GFX/194_Malias2.bin

.align 4
gfx195:
.incbin asm/bin/GFX/195_Malias2.bin

.align 4
gfx196:
.incbin asm/bin/GFX/196_Malias2.bin

.align 4
gfx197:
.incbin asm/bin/GFX/197_Malias2.bin

.align 4
gfx198:
.incbin asm/bin/GFX/198_Malias2.bin

.align 4
gfx199:
.incbin asm/bin/GFX/199_Malias2.bin

.align 4
gfx200:
.incbin asm/bin/GFX/200_Malias2.bin

.align 4
gfx201:
.incbin asm/bin/GFX/201_Malias2.bin

.align 4
gfx202:
.incbin asm/bin/GFX/202_Malias2.bin

.align 4
gfx203:
.incbin asm/bin/GFX/203_Malias2.bin

.align 4
gfx204:
.incbin asm/bin/GFX/204_Malias2.bin

.align 4
gfx205:
.incbin asm/bin/GFX/205_Malias2.bin

.align 4
gfx206:
.incbin asm/bin/GFX/206_Malias2.bin

.align 4
gfx207:
.incbin asm/bin/GFX/207_Malias2.bin

.align 4
gfx208:
.incbin asm/bin/GFX/208_Malias2.bin

.align 4
gfx209:
.incbin asm/bin/GFX/209_Malias2.bin

.align 4
gfx210:
.incbin asm/bin/GFX/210_Malias2.bin

.align 4
gfx211:
.incbin asm/bin/GFX/211_Malias2.bin

.align 4
gfx212:
.incbin asm/bin/GFX/212_Malias2.bin

.align 4
gfx213:
.incbin asm/bin/GFX/213_Malias2.bin

.align 4
gfx216:
.incbin asm/bin/GFX/216_Malias2.bin

.align 4
gfx217:
.incbin asm/bin/GFX/217_Malias2.bin

.align 4
gfx2753:
.incbin asm/bin/GFX/2753_Malias2.bin

.align 4
gfx2754:
.incbin asm/bin/GFX/2754_Malias2.bin

.align 4
gfx2761:
.incbin asm/bin/GFX/2761_Malias2.bin

.close
