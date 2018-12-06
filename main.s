; vim: set et ts=8 sw=8 sts=8 syntax=64tass:

        * = $0801

        DYSP_HEIGHT = $60


        FOCUS_SPRITES = $3d80

;        SID_PATH = "dexion_intro.sid"
;        SID_LOAD = $0830
;        SID_INIT = $0b06
;        SID_PLAY = $0b3e

        SID_PATH = "Old_Level_2.sid"
        SID_LOAD = $1000
        SID_INIT = $1000
        SID_PLAY = $1003


        .word (+), 2018
        .null $9e, format("%d", init)
+       .word 0


init
        jsr $fda3
        jsr $fd15
        jsr $ff5b
        sei
        lda #$35
        sta $01
        lda #0
        jsr SID_INIT

        jsr screen_setup

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
        lda #$17
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
        cli
        jmp *
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


;.byte $00, $40
;        .byte $30, $40
;        .byte $60, $40
 ;      .byte $90, $40
 ;       .byte $c0, $40
;
;        .byte 0



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

        ldx #$10
-       lda sprite_positions,x
        sta $d000,x
        dex
        bpl -
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
        lda #$01        ; 2
        sta $d02a       ; 4
        sta $d02b       ; 4
        sta $d02c       ; 4
        sta $d02d       ; 4
        sta $d02e       ; 4
                        ; ---
                        ; 46

        ldx #<(FOCUS_SPRITES >> 6) + 0        ; 2
        stx $07fb       ; 4

        ldx #<(FOCUS_SPRITES >> 6) + 1 + 5        ; 2
        stx $07fc       ; 4

        ldx #<(FOCUS_SPRITES >> 6) + 2        ; 2
        stx $07fd       ; 4

        ldx #<(FOCUS_SPRITES >> 6) + 3 + 5        ; 2
        stx $07fe       ; 4

        ldx #<(FOCUS_SPRITES >> 6) + 4        ; 2
        stx $07ff       ; 4


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
        nop
        nop
        nop
        ;bit $ea

        nop
        jsr dysp
        lda #6
        sta $d021
        sta $d020
        lda #$1b
        sta $d011

        dec $d020
        jsr wipe_clock_slide
        dec $d020
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
        lda #$00
        sta $d000
        lda #$30
        sta $d002
        lda #$60
        sta $d004
        lda #$90
        sta $d006
        lda #$c0
        sta $d008
        lda #$f0
        sta $d00a
        lda #$20
        sta $d00c
        lda #$50
        sta $d00e
        lda #%11000000
        sta $d010
        ldx #$f8
        stx $07f8
        inx
        stx $07f9
        inx
        stx $07fa
        inx
        stx $07fb
        inx
        stx $07fc
        inx
        stx $07fd
        inx
        stx $07fe
        inx
        stx $07ff
        lda #$01
        sta $d025
        lda #$0e
        sta $d026
        lda #$03
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

        jsr stretcher
        lda #0
        sta $d015

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
        ldx #50
-       dex
        bpl -
        lda #$1b
        sta $d011
        dec $d020
        jsr update_xpos
        dec $d020
        jsr update_ypos
        dec $d020
        jsr SID_PLAY
;        jsr wipe_clock_slide
        dec $d020
        jsr update_clock_slide
        dec $d020
        ;jsr color_cycle_text
        lda #6
        sta $d020



        lda #$29
        ldx #<irq1
        ldy #>irq1
        jmp do_irq

screen_setup .proc
        ldx #$4f
-       lda presents_text,x
        sta $0400,x
        lda #$01
        sta $d800,x
        dex
        bpl -
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
        sta $0334

        lda x_sinus,x
        sta sprite_positions + 6

        #upd8_x X_ADC - 2

        lda x_sinus,x
        clc
        adc #$30
        sta sprite_positions + 8
        bcc +
        lda $0334
        ora #%00010000
        sta $0334
+
        #upd8_x X_ADC - 4
        lda x_sinus,x
        clc
        adc #$60
        sta sprite_positions + 10
        bcc +
        lda $0334
        ora #%00100000
        sta $0334
+

        #upd8_x X_ADC - 6
        lda x_sinus,x
        clc
        adc #$90
        sta sprite_positions + 12
        bcc +
        lda $0334
        ora #%01000000
        sta $0334
+

        #upd8_x X_ADC - 8
        lda x_sinus,x
        clc
        adc #$c0
        sta sprite_positions + 14
        bcc +
        lda $0334
        ora #%10000000
        sta $0334
+
        lda $0334
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


presents_text
        .enc "screen"
        ;      0123456789abcdef0123456789abcdef01234567
        .text "Compyx of Focus not so proudly presents:"
        .text "- The ugliest Focus intro ever created -"



x_sinus
        .byte 71.5 + 72 * sin(range(128) * rad(360.0/128))

y_sinus
        .byte 23.5 + 24 * sin(range(128) * rad(360.0/128))






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
;        nop
;        nop
;        nop             ; 2
;        inx
 ;       cpx #$80
 ;       bne -
;        nop
        dex
        bpl -
.endp
        rts

        .align 128
d011_table
        ; inverted
.for row = 0, row < 96, row += 1
        .byte $10 + (((row + 3) & 7) ^ 7)
.next

        .align 256
.page
d021_table
        .byte $06, $00, $06, $04, $00, $06, $04, $0e
        .byte $00, $06, $04, $0e, $0f, $00, $06, $04
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
;
;        .byte $0b ,$00, $0b, $0c, $00, $0b, $0c, $0f
;        .byte $00, $0b, $0c, $0f, $0d, $00, $0b, $0c
;        .byte $0f, $0d, $01, $0d, $0f, $0f, $0c, $0b
;        .byte $00, $0d, $0f, $0c, $0b, $00, $0f, $0c
;        .byte $0b, $00, $0c, $0b, $00, $0b, $00, $00
.endp

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

        .align 256
.page
mask_table
        .fill 128, 0
.endp


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
        dec $d020

        lda sprite_positions + 7
        sec
        sbc #$34
        tay
        lda #%00000001

        ; turn into speedcode?
        .for i = 0, i < 42, i += 1
        sta mask_table + i,y
        .next
;        ldx #41
;-       sta mask_table,y
;        iny
;        dex
;        bpl -

        dec $d020
        lda sprite_positions + 9
        sec
        sbc #$34
        tay
        lda #%00000010
        jsr update_mask_table

        dec $d020
        lda sprite_positions + 11
        sec
        sbc #$34
        tay
        lda #%00000100
        jsr update_mask_table

        dec $d020
        lda sprite_positions + 13
        sec
        sbc #$34
        tay
        lda #%00001000
        jsr update_mask_table

        dec $d020
        lda sprite_positions + 15
        sec
        sbc #$34
        tay
        lda #%00010000
        jsr update_mask_table


        dec $d020

        ; generate final clock slide table

        ; speedcode
.for i = 0, i < DYSP_HEIGHT, i += 1

        ldy mask_table + i
        lda cycle_table,y
        sta timing + (DYSP_HEIGHT - i) - 5      ;why again?
.next
        rts




; speedcode
update_mask_table
        sta $02
.for i = 0, i < 42, i += 1
        lda mask_table + i,y
        ora $02
        sta mask_table + i,y
.next
        rts


color_cycle_text .proc
        ldx #0
-       lda $d801,x
        sta $d800,x
        lda $d829,x
        sta $d828,x
        inx
        cpx #$28
        bne -
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

text_colors
        .byte 6, 14, 3, 1, 3, 14, 6, 0
        .byte 2, 10, 7, 1, 7, 10, 2, 0
        .byte 11, 12, 15, 1, 15, 12, 11, 0
        .byte 9, 5, 13, 1, 13, 5, 9, 0
        .byte $ff

.page
stretcher
        ldx #0
        ldy #0
-       sty $d017
        lda d017_table,x
        sta $d017
        lda d011_table2 + 0 ,x
        bit $ea
        nop
        nop
        dec $d016
        sta $d011
        inc $d016
        inx
        cpx #72
        bne -
        rts
.endp

        .align 128
.page
d017_table
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
        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $ff, 0

        .byte $ff, $ff, $ff, 0
        .byte $ff, $ff, $00, 0
        .byte $ff, $ff, $00, 0
        .byte $ff, $ff, $00, 0

        .byte $ff, $ff, $00, 0
        .byte $ff, $ff, $00, 0
        .byte $ff, $00, $00, 0
.endp

.page
d011_table2
        .for i = 0, i < 96, i += 1
        .byte i & 7 | $18
        .next
.endp



        * = FOCUS_SPRITES
        .binary "sprites3.bin"

