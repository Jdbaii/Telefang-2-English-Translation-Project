Update: December 18th, 2004
---------------------------------------------------
  DTE input support. Fixed some bugs, Thanks Normmatt!
Saving issues, Thanks KingMike. Other goodies as well!




Update: November 30th, 2004
---------------------------------------------------
 Quite a bit of changes. So many that I didn't even bother
noting them so I forgot what they were. I do remember changing
the tile editor to use one form and to support GBA and a few
other formats. I also added support for 16-Bit ASCII direct
input as well as 16-Bit ASCII and KANA searching! Just use
it damn it and stop complaining! If you don't like it,
then you can swallow an egg and get it stuck in your throat.
I'm just kidding! Anyway, Have fun!!!



Update: April 14th, 2004
---------------------------------------------------
The updated help file coming soon. But for now
These are some keys that were added to the tile
Editor.

Ctrl + (+)   = Incrememnt Palette starting index by 1
Ctrl + (-)   = Decrememnt Palette starting index by 1

Ctrl + Left  = Decrease the Tile Window's Width
Ctrl + Right = Increase the Tile Window's Width

Ctrl + UP   - Increment the PIXEL height of the tiles
Ctrl + DOWN - Decrement the PIXEL height of the tiles



- 2003
----------------------------------------------------
New feature added. Text dumping... It's a start...
Suggestions are welcome!!!!!

; Script codes

%offset		= print the current offset at that location
%dumpsize	= print the size of the data being dumped
%romname	= print the rom file name being read from
%tblname	= print the table file name being used to dump from
\n		= new line / carriage return

;	There are 256 possible codes
;	Format: 
;[flag] 	 [index]  [Linked String] strings must have " "
.code		 $05  	  "[newl]\n"
.code  	   =	 0       "\n[endl]\n\n[%offset]\n"


;[flag] 	 [index] [arguements] [Linked String] '_' indicates where values insert
.multicode	 0        0           "<blah_blah>"

;	these are the only variables allowed to have multiple lines
;	nothing is printed if the varibles aren't enabled...
;	the multi strings MUST be followed by the comma directly after
;	the last quotation mark!!!!!

;       this is printed at the start of the file being dumped to.
.startdump "\n",					
	   "////////////////////////////////\n",
 	   "// Start of text dump         //\n",
	   "////////////////////////////////\n",
           "\n\n\n{\n\n[%offset]\n" 

;        this is printed at the end of the file being dumped to.
.enddump  "\n\n\n\n",				
	  "////////////////////////////////\n",
 	  "// End of text dump           //\n",
	  "////////////////////////////////\n",
	  "Size of dump   : %dumpsize\n",
	  "Rom file name  : %romname\n",
	  "Table file name: %tblname\n"

;############################
; NOTE: For all the above   #
; examples, the '\n' does   #
; not get printed to a file #
;############################

;
; Table values
;
41=A
42=B
