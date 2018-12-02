; vim: set et ts=8 sw=8 sts=8 syntax=64tass:

        * = $0801

        FOCUS_SPRITES = $2000

        SID_PATH = "dexion_intro.sid"
        SID_LOAD = $0830
        SID_INIT = $0b06
        SID_PLAY = $0b3e


        .word (+), 2018
        .null $9e, format("%d", init)
+       .word 0


        * = SID_LOAD
        .binary SID_PATH, $7e

        .align 256

init
        jsr $fda3
        jsr $fd15
        jsr $ff5b
        sei
        lda #$35
        sta $01
        lda #0
        jsr SID_INIT

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
        lda #%01111000
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
        lda #$0f        ; 2
        sta $d02a       ; 4
        sta $d02b       ; 4
        sta $d02c       ; 4
        sta $d02d       ; 4
        sta $d02e       ; 4
                        ; ---
                        ; 46

        ldx #$80        ; 2
        stx $07fb       ; 4
        inx             ; 2
        stx $07fc       ; 4
        inx             ; 2
        stx $07fd       ; 4
        inx             ; 2
        stx $07fe       ; 4
        inx             ; 2
        stx $07ff       ; 4
                        ; ---
                        ; 30

                        ; 76 total-> 101 - 76 = 25

        ldx #$02        ; 2
                        ; {
-       dex             ;   2
        bne -           ;   3 
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
        lda #$1b
        sta $d011

nop
        nop
        nop
        nop
        nop
        nop
        dec $d020
        jsr SID_PLAY
        dec $d020
        jsr update_xpos
        inc $d020
        inc $d020



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
        ldx #7
-       dex
        bpl -
        lda #$13
        sta $d011
        ldx #30
-       dex
        bpl -
        lda #$1b
        sta $d011

        lda #$29
        ldx #<irq1
        ldy #>irq1
        jmp do_irq




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






        .align 256

dysp
        ldy #8
        ;       ldx #$00
        ldx #$7f
-       lda d011_table,x
        sta $d016
        sta $d011
        sty $d016
        lda d021_table,x
        sta $d021
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
        lda d021_table + 40,x
        sta $d021
;        nop
;        nop
;        nop             ; 2
;        inx
 ;       cpx #$80
 ;       bne -
;        nop
        dex
        bpl -
        rts

        .align 256
d011_table
        ; inverted
.for row = 0, row < 128, row += 1
        .byte $10 + (((row + 3) & 7) ^ 7)
.next

        .align 256
d021_table
        .byte $06, $00, $06, $04, $00, $06, $04, $0e
        .byte $00, $06, $04, $0e, $0f, $00, $06, $04
        .byte $0e, $0f, $07, $00 ,$06, $04, $0e, $0f
        .byte $07, $01, $07, $0f, $0e, $04, $06, $00
        .byte $07, $0f, $0e, $04, $06, $00, $0f, $0e
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

        .byte $0b ,$00, $0b, $0c, $00, $0b, $0c, $0f
        .byte $00, $0b, $0c, $0f, $0d, $00, $0b, $0c
        .byte $0f, $0d, $01, $0d, $0f, $0f, $0c, $0b
        .byte $00, $0d, $0f, $0c, $0b, $00, $0f, $0c
        .byte $0b, $00, $0c, $0b, $00, $0b, $00, $00

        .align 256

timing
        ; inverted

        ; $7f
        .fill 128 - 16 - 42, 0

        .fill 42, 11
        .fill 16, 0


;        .fill 16, 0
;        .fill 42, 13
;        .fill 128-2, 0


update_xpos
        ldx #0

        lda #0
        sta $0334

        lda x_sinus,x
        sta sprite_positions + 6

        lda x_sinus,x
        clc
        adc #$30
        sta sprite_positions + 8
        bcc +
        lda $0334
        ora #%00010000
        sta $0334
+
        lda x_sinus,x
        clc
        adc #$60
        sta sprite_positions + 10
        bcc +
        lda $0334
        ora #%00100000
        sta $0334
+
        lda x_sinus,x
        clc
        adc #$90
        sta sprite_positions + 12
        bcc +
        lda $0334
        ora #%01000000
        sta $0334
+
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
        sta update_xpos + 1
        rts


x_sinus
        .byte 71.5 + 72 * sin(range(256) * rad(360.0/256))


cycle_table
        ; Number of cycles to skip in the clock slide

        .byte 0         ; no sprites,   use full clock slide
        .byte 5         ; mask %0000 1000       sprite 3 only
        .byte 7         ; mask %0001 0000       sprite 4 only
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



        * = FOCUS_SPRITES
        .binary "sprites.bin"




