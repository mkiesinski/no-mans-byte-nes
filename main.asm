    .inesprg 1          ; 1x 16KB PRG
    .ineschr 1          ; 1x 8KB CHR
    .inesmap 0          ; no mapper
    .inesmir 1          ; background mirroring

    .rsset $0000
    .include "variables.asm"
    .include "constants.asm"

    .bank 0
    .org $C000

    .include "init.asm"

;;;;;;;; INITIALIZATION




;;;;;;;; SET STARTING STATE
    LDA #STATEOVERWORLDINIT
    STA gamestate

LoadBackground:
  LDA $2002             ; read PPU status to reset the high/low latch
  LDA #$20
  STA $2006             ; write the high byte of $2000 address
  LDA #$00
  STA $2006             ; write the low byte of $2000 address
  LDX #$00              ; start out at 0
  LDY #$00
LoadBackgroundLoop:
  LDA #$2E     ; load data from address (background + the value in x)
  STA $2007             ; write to PPU
  INX                   ; X = X + 1
  CPX #$A0              ; Compare X to hex $80, decimal 128 - copying 128 bytes
  BNE LoadBackgroundLoop  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero
                        ; if compare was equal to 128, keep going down    
    INY
    CPY #$04
    BNE LoadBackgroundLoop

LoadAttr:
    LDA $2002
    LDA #$23
    STA $2006
    LDA #$C0
    STA $2006
    LDX #$00
LoadAttrLoop:
    LDA #$00
    STA $2007
    INX
    CPX #$40
    BNE LoadAttrLoop

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA $2000
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA $2001
Forever:
    JMP Forever


NMI
    LDA #$00
    STA $2003
    LDA #$02
    STA $4014

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA $2000
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA $2001
    LDA #$00        ;;tell the ppu there is no background scrolling
    STA $2005
    STA $2005

    ;;;;;; graphic updates end here

    JSR ReadControler

    .include "engine/engine.asm"

    RTI



;;;;;;;;;;;;;;

    .include "engine/overworld.asm"
    .include "engine/readController.asm"

UpdateSprites:
    RTS

    ;;;;;;;;;;;;;;;;;;;;;;

    .bank 1
    .org $E000

palette:
  .db $22,$2A,$33,$02,  $22,$16,$17,$0F,  $22,$30,$21,$0F,  $22,$27,$17,$0F   ;;background palette
  .db $30,$1E,$18,$37,  $22,$02,$38,$3C,  $22,$1C,$15,$14,  $22,$02,$38,$3C   ;;sprite palette

    .include "sprites/sprites.asm"

    .org $FFFA

    .dw NMI
    .dw RESET
    .dw 0

    ;;;;;;;;;;;;;;;;;;;;;

    .bank 2             ; import graphics
    .org $0000
    .incbin "graphics/bank.chr"