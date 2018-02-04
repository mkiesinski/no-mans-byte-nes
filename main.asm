    .inesprg 1          ; 1x 16KB PRG
    .ineschr 1          ; 1x 8KB CHR
    .inesmap 0          ; no mapper
    .inesmir 1          ; background mirroring

    .include "nes_constants.asm"
    .include "constants.asm"

    .rsset $0000
    .include "variables.asm"

    .bank 0
    .org $C000

    .include "init.asm"

;;;;;;;; INITIALIZATION

    LDA #$80            ; set initial position
    STA playerPosX
    STA playerPosY

    LDA #DOWN
    STA playerDirection     ; set player direction down

;;;;;;;; SET STARTING STATE
    LDA #STATEOVERWORLD
    STA gamestate

LoadBackground:
  LDA PPUCTRL             ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPUADDR             ; write the high byte of $2000 address
  LDA #$00
  STA PPUADDR             ; write the low byte of $2000 address
  LDX #$00              ; start out at 0
  LDY #$00
LoadBackgroundLoop:
  LDA #$2B     ; load data from address (background + the value in x)
  STA PPUDATA             ; write to PPU
  INX                   ; X = X + 1
  CPX #$C0              ; Compare X to hex $80, decimal 128 - copying 128 bytes
  BNE LoadBackgroundLoop  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero
                        ; if compare was equal to 128, keep going down    
    INY
    CPY #$04
    BNE LoadBackgroundLoop

LoadAttr:
    LDA PPUSTATUS
    LDA #$23
    STA PPUADDR
    LDA #$C0
    STA PPUADDR
    LDX #$00
LoadAttrLoop:
    LDA #$00
    STA PPUDATA
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
    STA OAMADDR
    LDA #$02
    STA OAMDMA

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PPUCTRL
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA PPUMASK
    LDA #$00        ;;tell the ppu there is no background scrolling
    STA PPUSCROLL
    STA PPUSCROLL

    ;;;;;; graphic updates end here

    JSR ReadControler

    .include "engine/engine.asm"

    RTI



;;;;;;;;;;;;;;

    .include "engine/overworld.asm"
    .include "engine/drawsprite.asm"
    .include "engine/readController.asm"
    ;;;;;;;;;;;;;;;;;;;;;;

    .bank 1
    .org $E000

palette:
  .db $22,$37,$33,$02,  $22,$16,$17,$0F,  $22,$30,$21,$0F,  $22,$27,$17,$0F   ;;background palette
  .db $30,$1E,$16,$27,  $22,$02,$38,$3C,  $22,$1C,$15,$14,  $22,$02,$38,$3C   ;;sprite palette

    .include "sprites/sprites.asm"

    .org $FFFA

    .dw NMI
    .dw RESET
    .dw 0

    ;;;;;;;;;;;;;;;;;;;;;

    .bank 2             ; import graphics
    .org $0000
    .incbin "graphics/bank.chr"