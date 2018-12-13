; vim: set et ts=8 sw=8 sts=8 syntax=64tass:

        * = $0801

        ; videoram for the "present bla" text
        VIDRAM = $0800
        ; sprite pointers relative to the vidram
        SPRPTRS = VIDRAM + $03f8

        DEBUG = 0

        DYSP_HEIGHT = $60

        BG_COLOR = 4

        ; location of the 5 x 2 'focus' sprites
        FOCUS_SPRITES = $3d80

        ; sprite font (32 sprites = 32 * 64 = $0800)
        FONT_SPRITES = $3000

;        SID_PATH = "dexion_intro.sid"
;        SID_LOAD = $0830
;        SID_INIT = $0b06
;        SID_PLAY = $0b3e

        ; Sweet tune by Link
        SID_PATH = "Old_Level_2.sid"
        SID_LOAD = $1000
        SID_INIT = $1000
        SID_PLAY = $1003

        tmp = $02

        .word (+), 2018
        .null $9e, format("%d", init)
+       .word 0


        * = $0850

init
        jsr $fda3
        jsr $fd15
        jsr $ff5b

        sei
        lda #$35
        sta $01
        lda #$7f
        sta $dc0d
        sta $dd0d
        ldx #$0
        stx $dc0e
        stx $dd0e
        stx $3fff
        inx
        stx $d01a
        lda #$1b
        sta $d011
        lda #((VIDRAM & $3fff) >> 10) << 4 | $07
        sta $d018
        lda #$29
        ldx #<irq1
        ldy #>irq1
        sta $d012
        stx $fffe
        sty $ffff
        ldx #<break
        ldy #>break
        stx $fffa
        sty $fffb
        stx $fffc
        sty $fffd
        bit $dc0d
        bit $dd0d
        inc $d019

        lda #0
        jsr SID_INIT

        jsr screen_setup


        cli
loopie  lda $dc01
        cmp #$ef
        bne loopie

        sei
        lda #$37
        sta $01
        jmp $fce2

        .align 128

.page
irq1
        ; stabilize raster
        pha
        txa
        pha
        tya
        pha
        lda #$2a
        ldx #<irq2
        ldy #>irq1
        sta $d012
        stx $fffe
        sty $ffff
        nop
        inc $d019
        tsx
        cli
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
irq2
        txs
        ldx #8
-       dex
        bne -
        bit $ea
        lda $d012
        cmp $d012
        beq +
+
.if DEBUG
        dec $d020
.else
        nop
        nop
        nop
.endif
        ldx #$10
-       lda sprite_positions,x
        sta $d000,x
        dex
        bpl -

.endp
        ;lda #%11111000
        lda #%11111000
        sta $d015

        ; ldx #$14      ; 2
        ; - dex         ; 20 * 2 = 40
        ; bne -         ; 19 * 3 + 2  = 59
                        ; ----
                        ; 101

        lda #%11111000
        sta $d01d       ; 4
        sta $d017       ; 4 
        sta $d01c       ; 4

        lda #$0c        ; 2
        sta $d025       ; 4
        lda #$0b        ; 2
        sta $d026       ; 4

lcolor  lda #$01        ; 2
        sta $d02a       ; 4
        sta $d02b       ; 4
        sta $d02c       ; 4
        sta $d02d       ; 4
        sta $d02e       ; 4
                        ; ---
                        ; 46
lptr0   ldx #<(FOCUS_SPRITES >> 6) + 0          ; 2
        stx SPRPTRS + 3                  ; 4

lptr1   ldx #<(FOCUS_SPRITES >> 6) + 1 + 5      ; 2
        stx SPRPTRS + 4                  ; 4

lptr2   ldx #<(FOCUS_SPRITES >> 6) + 2          ; 2
        stx SPRPTRS + 5                  ; 4

lptr3   ldx #<(FOCUS_SPRITES >> 6) + 3 + 5      ; 2
        stx SPRPTRS + 6                  ; 4

lptr4   ldx #<(FOCUS_SPRITES >> 6) + 4          ; 2
        stx SPRPTRS + 7                  ; 4


                        ; ---
                        ; 30

                        ; 76 total-> 101 - 76 = 25

        ldx #$02        ; 2
-       dex             ; 2
        bne -           ; 3 if taken
        nop
        nop
        nop
        nop
;        nop
;        nop
;        nop
        ;bit $ea

        nop
        jsr dysp
        lda #BG_COLOR
        sta $d021
        sta $d020
        lda #$1b
        sta $d011

.if DEBUG
        dec $d020
.else
        nop
        nop
        nop
.endif
        jsr wipe_clock_slide
.if DEBUG
        dec $d020
.else
        nop
        nop
        nop
.endif
        ; jsr update_clock_slide

;        dec $d020
;        jsr SID_PLAY
;        dec $d020

        lda #$ff
        sta $d015
        sta $d01d
        sta $d01c
        lda #0
        sta $d017

        lda #$a4
        sta $d001
        sta $d003
        sta $d005
        sta $d007
        sta $d009
        sta $d00b
        sta $d00d
        sta $d00f
xpos0   lda #$00
        sta $d000
xpos1   lda #$30
        sta $d002
xpos2   lda #$60
        sta $d004
xpos3   lda #$90
        sta $d006
xpos4   lda #$c0
        sta $d008
xpos5   lda #$f0
        sta $d00a
xpos6   lda #$20
        sta $d00c
xpos7   lda #$50
        sta $d00e
xmsb    lda #%11000000
        sta $d010
xptr0   ldx #$c0
        stx SPRPTRS + 0
xptr1   ldx #$c0
        stx SPRPTRS + 1
xptr2   ldx #$c0
        stx SPRPTRS + 2
xptr3   ldx #$c0
        stx SPRPTRS + 3
xptr4   ldx #$c0
        stx SPRPTRS + 4
xptr5   ldx #$c0
        stx SPRPTRS + 5
xptr6   ldx #$c0
        stx SPRPTRS + 6
xptr7   ldx #$c0
        stx SPRPTRS + 7
xmc1    lda #$01
        sta $d025
xmc2    lda #$0e
        sta $d026
xscol   lda #$03
        sta $d027
        sta $d028
        sta $d029
        sta $d02a
        sta $d02b
        sta $d02c
        sta $d02d
        sta $d02e

        ldx #7
-       dex
        bpl -
        nop
        nop
        nop
        nop
        jsr stretcher
        lda #0
        sta $d015
.if DEBUG
        lda $d012
        sta $0400
        dec $d020
.endif
        jsr color_cycle_text
.if DEBUG
        inc $d020
.endif

        lda #$f9
        ldx #<irq3
        ldy #>irq3

do_irq
        sta $d012
        stx $fffe
        sty $ffff
        lda #1
        sta $d019
        pla
        tay
        pla
        tax
        pla
break   rti

irq3
        pha
        txa
        pha
        tya
        pha
        ldx #3
-       dex
        bpl -
        lda #$13
        sta $d011
        lda #0
        sta $d015
        jsr scroll_sprites
;        ldx #50
;-       dex
;        bpl -
;        lda #$1b
;        sta $d011
.if DEBUG
        dec $d020
.endif
        jsr update_xpos
        lda #$1b
        sta $d011
.if DEBUG
        dec $d020
.endif
        jsr update_ypos
.if DEBUG
        dec $d020
.endif
        jsr SID_PLAY
.if DEBUG
        dec $d020
.endif
        jsr update_clock_slide
.if DEBUG
        dec $d020
.endif
        jsr wipe_stretch_table
.if DEBUG
        dec $d020
.endif
        jsr update_stretch_table
.if DEBUG
        dec $d020
.endif
        jsr switch_logo_sprites
.if DEBUG
        dec $d020
.endif
        jsr flash_logo

        lda #BG_COLOR
        sta $d020



        lda #$29
        ldx #<irq1
        ldy #>irq1
        jmp do_irq

screen_setup .proc
        ldx #((2 * 40) - 1)
-       lda presents_text,x
        sta VIDRAM,x
        dex
        bpl -
        lda #BG_COLOR
        inx
-       sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $dae8,x
        inx
        bne -
        rts
.pend

upd8_x .macro
        txa
        clc
        adc #\1
        and #$7f
        tax
.endm
        X_ADC = 16

update_xpos
        ldx #0

        lda #0
        sta tmp

        lda x_sinus,x
        sta sprite_positions + 6

        #upd8_x X_ADC - 2

        lda x_sinus,x
        clc
        adc #$30
        sta sprite_positions + 8
        bcc +
        lda tmp
        ora #%00010000
        sta tmp
+
        #upd8_x X_ADC - 4
        lda x_sinus,x
        clc
        adc #$60
        sta sprite_positions + 10
        bcc +
        lda tmp
        ora #%00100000
        sta tmp
+

        #upd8_x X_ADC - 6
        lda x_sinus,x
        clc
        adc #$90
        sta sprite_positions + 12
        bcc +
        lda tmp
        ora #%01000000
        sta tmp
+

        #upd8_x X_ADC - 8
        lda x_sinus,x
        clc
        adc #$c0
        sta sprite_positions + 14
        bcc +
        lda tmp
        ora #%10000000
        sta tmp
+
        lda tmp
        sta sprite_positions + $10

        lda update_xpos + 1
        clc
        adc #1
        and #$7f
        sta update_xpos + 1
        rts

        Y_ADC = 40

update_ypos
        ldx #0

        ldy #6
-
        lda y_sinus,x
        clc
        adc #$34
        sta sprite_positions + 1,y
        txa
        clc
        adc #Y_ADC
        and #$7f
        tax
        iny
        iny

        cpy #$10
        bne -

        lda update_ypos + 1
        clc
        adc #3
        and #$7f
        sta update_ypos + 1
        rts
sprite_positions
        .byte 0, 0
        .byte 0, 0
        .byte 0, 0

        .byte $00, $40
        .byte $50, $40
        .byte $a0, $40
        .byte $f0, $40
        .byte $30, $40

        .byte %10000000

 

        .align 64
dysp
        ldy #8
        ;       ldx #$00
        ldx #DYSP_HEIGHT - 1
.page
-       lda d011_table,x
        sta $d016
        sta $d011
        sty $d016
        lda d021_table,x
        sta $d026
        lda d025_table,x
        sta $d025

        lda timing,x            ; max 13
        sta _delay + 1
_delay  bpl * + 2
        cpx #$e0        ; 2
        cpx #$e0        ; 2
        cpx #$e0        ; 2
        cpx #$e0        ; 2
        cpx #$e0        ; 2
        cpx #$e0        ; 2
        bit $ea         ; 3
        dex
        bpl -
.endp
        rts

        .align 32
.page
cycle_table
        ; Number of cycles to skip in the clock slide

        .byte 0         ; no sprites,   use full clock slide
        .byte 5         ; mask %0000 1000       sprite 3 only
        .byte 5         ; mask %0001 0000       sprite 4 only
        .byte 7         ; mask %0001 1000       sprite 3 & 4

        .byte 5         ; mask %0010 0000       sprite 5 only
        .byte 9         ; mask %0010 0100       sprite 5 & 3
        .byte 7         ; mask %0010 1000       sprite 5 & 4
        .byte 9         ; mask %0011 1000       sprite 5 4 3

        .byte 5         ; mask %0100 0000       sprite 6 only
        .byte 10        ; mask %0100 1000       sprite 6 & 3
        .byte 9         ; mask %0101 0000       sprite 6 & 4
        .byte 11        ; mask %0101 1000       sprite 6 & 3 & 4

        .byte 7         ; mask %0110 0000       sprite 6 & 5
        .byte 11        ; mask %0110 1000       sprite 6 & 5 & 3
        .byte 9         ; mask %0111 0000       sprite 6 & 5 & 4
        .byte 11        ; mask %0111 1000       sprite 6 & 5 & 4 & 3


        .byte 5         ; mask %1000 0000       sprite 7
        .byte 9         ; mask %1000 1000       sprite 7 & 3
        .byte 9         ; mask %1001 0000       sprite 7 & 4
        .byte 12        ; mask %1001 1000       sprite 7 & 3 & 4

        .byte 9         ; mask %1010 0000       sprite 7 & 5
        .byte 13        ; mask %1010 1000       sprite 7 & 5 & 3
        .byte 11        ; mask %1011 0000       sprute 7 & 5 & 4
        .byte 13        ; mask %1011 1000       sprite 7 & 5 & 3 & 4

        .byte 7         ; mask %1100 0000       sprite 7 & 6
        .byte 12        ; mask %1100 1000       sprite 7 & 6 & 3
        .byte 11        ; mask %1101 0000       sprite 7 & 6 & 4
        .byte 13        ; mask %1101 1000       sprite 7 & 6 & 3 & 4

        .byte 9         ; mask %1110 0000       sprite 7 & 6 & 5
        .byte 13        ; mask %1110 1000       sprite 7 & 6 & 5 & 3
        .byte 11        ; mask %1111 0000       sprite 7 & 6 & 5 & 4
        .byte 13        ; mask %1111 1000       sprite 7 & 6 & 5 & 4 & 3
.endp


        .align 128
d011_table
        ; inverted
.for row = 0, row < 96, row += 1
        .byte (((row + 3) & 7) ^ 7) | $10
.next

        .align 128
.page
d021_table
        ;.byte $06, $00, $06, $04, $00, $06, $04, $0e
        ;.byte $00, $06, $04, $0e, $0f, $00, $06, $04

        .byte $0e, $0f, $0d, $00 ,$06, $04, $0e, $0f
        .byte $0d, $01, $0d, $0f, $0e, $04, $06, $00

        .byte $0d, $0f, $0e, $04, $06, $00, $0f, $0e
        .byte $04, $06, $00, $0e, $04, $06, $00, $04

        .byte $06, $00, $06, $00, $09, $08, $0a, $0f
        .byte $07, $01, $07, $0f, $0a, $08, $09, $00

        .byte $06, $00, $06, $04, $00, $06, $04, $0e
        .byte $00, $06, $04, $0e, $0f, $00, $06, $04

        .byte $0e, $0f, $07, $00 ,$06, $04, $0e, $0f
        .byte $07, $01, $07, $0f, $0e, $04, $06, $00

        .byte $07, $0f, $0e, $04, $06, $00, $0f, $0e
        .byte $04, $06, $00, $0e, $04, $06, $00, $04

        .byte $06, $00, $06, $00, $09, $08, $0a, $0f
        .byte $07, $01, $07, $0f, $0a, $08, $09, $00
.endp
        .align 128
.page
d021_table2
        .byte $01, $03, $0f, $0e, $04, $06, $00, $00
        .byte $06, $00, $06, $04, $06, $00, $06, $04
        .byte $0e, $04, $06, $00, $06, $00, $06, $04

        .byte $0e, $0f, $0d, $00 ,$06, $04, $0e, $0f
        .byte $0d, $01, $0d, $0f, $0e, $04, $06, $00

        .byte $0d, $0f, $0e, $04, $06, $00, $0f, $0e
        .byte $04, $06, $00, $0e, $04, $06, $00, $04

;        .byte $06, $00, $06, $00, $09, $00, $06, $00
        .byte $0e, $04, $06, $00, $06, $00, $06, $04

        .byte $06, $06, $06, $04, $06, $00, $06, $04

;        .byte $07, $0f, $0e, $04, $06, $00, $0f, $0e
;        .byte $04, $06, $00, $0e, $04, $06, $00, $04

;        .byte $06, $00, $06, $00, $09, $08, $0a, $0f
;        .byte $07, $01, $07, $0f, $0a, $08, $09, $00
.endp
        .align 128
.page
d025_table
        .byte $09, $00, $09, $02, $00, $09, $02, $0a
        .byte $00, $09, $02, $0a, $0f, $00, $09, $02
        .byte $0a, $0f, $07, $00, $09, $02, $0a, $0f
        .byte $07, $01, $07, $0f, $0a, $02, $09, $00
        .byte $07, $0f, $0a, $02, $09, $00, $0f, $0a
        .byte $02, $09, $00, $0a, $02, $09, $00, $02
        .byte $09, $00, $09, $00
        .byte $09, $00, $09, $02, $00, $09, $02, $0a
        .byte $00, $09, $02, $0a, $0f, $00, $09, $02
        .byte $0a, $0f, $07, $00, $09, $02, $0a, $0f
        .byte $07, $01, $07, $0f, $0a, $02, $09, $00
        .byte $07, $0f, $0a, $02, $09, $00, $0f, $0a
        .byte $02, $09, $00, $0a, $02, $09, $00, $02
        .byte $09, $00, $09, $00
.endp

        .align 128


        .cerror * > $1000, "Code overlaps SID"


        * = SID_LOAD
        .binary SID_PATH, $7e

        .align 128
.page
timing
        ; inverted

        ; $7f
        .fill DYSP_HEIGHT - 16 - 42, 0

        .fill 42, 9

        .fill 16, 0             ; this assumes Y pos $40


;        .fill 16, 0
;        .fill 42, 13
;        .fill 128-2, 0

        .fill 32 ,0
.endp

        .align 128
;.page
mask_table
        .fill 128, 0
; .endp

 x_sinus
        .byte 71.5 + 72 * sin(range(128) * rad(360.0/128))

y_sinus
        .byte 23.5 + 24 * sin(range(128) * rad(360.0/128))


presents_text
        .enc "screen"
        ;      0123456789abcdef0123456789abcdef01234567
        .text "Compyx of Focus not so proudly presents:"
        .text "- The ugliest Focus intro ever created -"





wipe_clock_slide
;        ldx #DYSP_HEIGHT - 1
;        lda #0
;;-       sta timing,x
;        sta mask_table,x
;        dex
;        bpl -
;        rts
        lda #0
.for i = 0, i < DYSP_HEIGHT + 5, i += 1
        sta timing - 5 + i
        sta mask_table + i
.next
        rts





update_clock_slide
.if DEBUG
        dec $d020
.endif
        lda sprite_positions + 7
        sec
        sbc #$34
        tay
;        lda #%00000001

;        ; turn into speedcode?
;        .for i = 0, i < 42, i += 1
;        sta mask_table + i,y
;        .next
;        ldx #41
;-       sta mask_table,y
;        iny
;        dex
;        bpl -
        jsr update_mask_table_00001

.if DEBUG
        dec $d020
.endif
        lda sprite_positions + 9
        sec
        sbc #$34
        tay
        jsr update_mask_table_00010

.if DEBUG
        dec $d020
.endif
        lda sprite_positions + 11
        sec
        sbc #$34
        tay
        jsr update_mask_table_00100
.if DEBUG
        dec $d020
.endif
        lda sprite_positions + 13
        sec
        sbc #$34
        tay
        jsr update_mask_table_01000
.if DEBUG
        dec $d020
.endif
        lda sprite_positions + 15
        sec
        sbc #$34
        tay
        jsr update_mask_table_10000

.if DEBUG
        dec $d020
.endif

        ; generate final clock slide table

        ; speedcode
.for i = 0, i < DYSP_HEIGHT, i += 1

        ldy mask_table + i
        lda cycle_table,y
        sta timing + (DYSP_HEIGHT - i) - 5      ;why again?
.next
        rts




; speedcode
;update_mask_table .
;        sta $02
;.for i = 0, i < 42, i += 1
;        lda mask_table + i,y
;        ora $02
;        sta mask_table + i,y
;.next
;        rts


update_mask_table_00001
        lda #1
        .for i = 0, i < 42, i += 1
        sta mask_table + i,y
        .next
        rts

update_mask_table_00010
        .for i = 0, i < 42, i += 1
        lda mask_table + i,y
        ora #%00000010
        sta mask_table + i,y
        .next
        rts

update_mask_table_00100
        .for i = 0, i < 42, i += 1
        lda mask_table + i,y
        ora #%0000100
        sta mask_table + i,y
        .next
        rts

update_mask_table_01000
        .for i = 0, i < 42, i += 1
        lda mask_table + i,y
        ora #%0001000
        sta mask_table + i,y
        .next
        rts

update_mask_table_10000
        .for i = 0, i < 42, i += 1
        lda mask_table + i,y
        ora #%0010000
        sta mask_table + i,y
        .next
        rts






text_colors
        .byte 6, 14, 3, 1, 3, 14, 6, 0, 0, 0, 0, 0, 0, 0
        .byte 2, 10, 7, 1, 7, 10, 2, 0, 0, 0, 0, 0, 0, 0
        .byte 11, 12, 15, 1, 15, 12, 11, 0, 0, 0, 0, 0, 0
        .byte 9, 5, 13, 1, 13, 5, 9, 0, 0, 0, 0, 0, 0
        .byte $ff

.page
stretcher
        ldx #71
        ldy #0
-       sty $d017
        lda d017_table,x
        sta $d017
        lda d021_table2 + 0,x
;        bit $ea
;        nop
;        nop
;        nop
        dec $d016
        sta $d025
        inc $d016
        lda d011_table2,x
        sta $d011,y
        dex
        bpl -
        lda #BG_COLOR
        sta $d021
        rts
.endp

        .align 128
.page
d017_table      ; 72 bytes
        .byte $00, $ff, $ff, $ff
        .byte $00, $ff, $ff, $ff
        .byte $ff, $ff, $ff, $ff
        .byte $ff, $ff, $ff, 0

        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $ff, 0

        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $ff, 0

        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $00, 0
        .byte $ff, $ff, $00, 0
        .byte $ff, $ff, $00, 0

        .byte $ff, $ff, $ff, $ff
        .byte $ff, $ff, $00, $ff
.endp

        .align 128
.page
d011_table2
        .for i = 0, i < 80, i += 1
        .byte (i & 7 ^ 7) | $18
        .next
.endp


scroll_x
        .byte 0
scroll_msb
        .byte 0

scroll_coder_colors
        .byte $01, $06, $0e, 0
        .byte $07, $02, $0a, 0

        .byte $0f, $0b, $0c, 0
        .byte $01, $05, $0d, 0

        .byte $03, $00, $0e, 0
        .byte $0a, $00, $02, 0

        .byte $01, $00, $06, 0
        .byte $01, $00, $0e, 0

update_scroll_pos
        lda scroll_x
        clc
        adc #$f8 - $40
        sta xpos0 + 1

        lda scroll_x
        sta xpos1 + 1

        clc
        adc #$40
        sta xpos2 + 1
        adc #$40
        sta xpos3 + 1
        adc #$40
        sta xpos4 + 1
        lda scroll_x
        sta xpos5 + 1
        clc
        adc #$40
        sta xpos6 + 1
        adc #$40
        sta xpos7 + 1

        lda scroll_msb
        ora #%11100001
        sta scroll_msb
        sta xmsb + 1
        rts

scroll_sprites

        lda scroll_x
        sec
        sbc #3
        and #$3f
        sta scroll_x
        bcc +

        jsr update_scroll_pos

        rts
+
        lda xptr1 + 1
        sta xptr0 + 1
        lda xptr2 + 1
        sta xptr1 + 1
        lda xptr3 + 1
        sta xptr2 + 1
        lda xptr4 + 1
        sta xptr3 + 1
        lda xptr5 + 1
        sta xptr4 + 1
        lda xptr6 + 1
        sta xptr5 + 1
        lda xptr7 + 1
        sta xptr6 + 1


        jsr update_scroll_pos

txtidx  lda scroll_text
        bne +
        lda #<scroll_text
        ldx #>scroll_text
        sta txtidx + 1
        stx txtidx + 2

        rts
+
        cmp #$40
        bcc +
        and #$07
        asl
        asl
        tax
        lda scroll_coder_colors,x
        sta xmc1 + 1
        lda scroll_coder_colors + 1,x
        sta xmc2 + 1
        lda scroll_coder_colors + 2,x
        sta xscol + 1
        lda #$00
+
        and #$1f
        adc #$c0
        sta xptr6 + 1

        inc txtidx + 1
        bne +
        inc txtidx + 2
+
        rts


switch_logo_sprites .proc

delay   lda #$40
        beq +
        dec delay +1
        rts
+
        lda #$40
        sta delay + 1

index   ldx #0
        lda logo_pointers + 0,x
        sta lptr0 + 1
        lda logo_pointers + 1,x
        sta lptr1 + 1
        lda logo_pointers + 2,x
        sta lptr2 + 1
        lda logo_pointers + 3,x
        sta lptr3 + 1
        lda logo_pointers + 4,x
        sta lptr4 + 1

        lda index + 1
        clc
        adc #5
        sta index + 1
        cmp #logo_pointers_end - logo_pointers
        bcc +
        lda #0
        sta index + 1
+       rts
.pend

flash_logo .proc
delay   lda #$03
        beq +
        dec delay +1
        rts
+       lda #$03
        sta delay + 1

index   ldx #0
        lda text_colors,x
        bpl +
        ldx #0
        stx index + 1
        lda text_colors,x
+
        sta lcolor + 1
        inc index + 1
        rts
.pend


        MC1_SPR = (FOCUS_SPRITES & $3fff) / 64
        MC2_SPR = MC1_SPR + 5
logo_pointers
        .byte MC1_SPR + 0, MC1_SPR + 1, MC1_SPR + 2, MC1_SPR + 3 ,MC1_SPR + 4
        .byte MC1_SPR + 0, MC2_SPR + 1, MC1_SPR + 2, MC2_SPR + 3 ,MC1_SPR + 4
        .byte MC2_SPR + 0, MC2_SPR + 1, MC2_SPR + 2, MC2_SPR + 3 ,MC2_SPR + 4
        .byte MC2_SPR + 0, MC1_SPR + 1, MC2_SPR + 2, MC1_SPR + 3 ,MC2_SPR + 4
logo_pointers_end










        * = FONT_SPRITES
        .binary "sprites6.bin"


        * = FOCUS_SPRITES
        .binary "sprites3.bin"



        * = $4000

color_cycle_text .proc

        .for i = 0, i < 39, i += 1

        lda $d801 + i
        sta $d800 + i
        sta $d828 + i

        .next

index
        ldx #0
        lda text_colors,x
        bmi ++
        sta $d827
        sta $d84f

delay   lda #3
        beq +
        dec delay +1
        rts
+       lda #3
        sta delay + 1

        inc index +1
        rts
+
        ldx #0
        stx index +1
        rts
.pend



wipe_stretch_table .proc
        lda #$ff
        .for i = 0, i < 72, i += 1
        sta d017_table + i
        .next
        rts
.pend


stretch_table_sinus

        .byte 1.5 + 2 * sin(range(64) * rad(360.0/64))
        .byte 1.5 + 2 * sin(range(64) * rad(360.0/64))


update_stretch_table .proc

        ldy #0
        ldx #0

        .for i = 0, i < 20, i += 1

        txa
        clc
        adc stretch_table_sinus,y
        tax
        lda #0
        sta d017_table + 8 + i,x
;        tya
;        clc
;        adc #2
;        and #$3f
;        tay
        iny
        iny
        .next

        lda update_stretch_table + 1
        clc
        adc #$01
        and #$3f
        sta update_stretch_table + 1



        rts
.pend



scroll_text
        .enc "screen"
        .text "welcome to hopefully the ugliest focus intro ever"
        .byte $1b
        .text "   "
        .byte $41
        .text "i got frustrated trying to do both proper graphics and"
        .byte $42
        .text "proper code"
        .byte $1c
        .text " so i decided to go for some real ugly stuff"
        .byte $43
        .text " while still enjoying myself with some vicii trickery"
        .byte $1b, $1b, $1b, $44

        .text "the dysp is badly optimized "
        .text "and uses way too much rastime"
        .byte $1b, $1b
        .byte $45

        .text "     this scroller also sucks"
        .byte $1c
        .byte $42
        .text "since i forgot how to do a low cycle strecther"
        .byte $1b, $1b

        .byte $40
        .text "       "
        .byte $47
        .text "incomplete greetings to "

        .byte $40
        .text "vice team        "
        .byte $41
        .text "former focus members       "
        .byte $42
        .text "algorithm      "
        .byte $43
        .text "harekiet       "
        .byte $44
        .text "mr ammo        "
        .byte 45
        .text "ian coog      "
        .byte $46
        .text "jazzcat      "
        .byte $47
        .text "moloch       "
        .byte $40
        .text "bacchus       "
        .byte $41
        .text "raistlin        "

        .byte $47
        .text "and bob of censor"
        .byte $1c,$41
        .text "there is good chance some of the"
        .byte $44
        .text "trickery i use here"
        .byte $46
        .text "i got from looking at his code"
        .byte 41
        .byte $1b, $1b, $1b
        .text "                "

        .byte 0


