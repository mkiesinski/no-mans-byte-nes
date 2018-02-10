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
    LDA #STATE_OVERWORLD_INIT
    STA gamestate

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PPUCTRL
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA PPUMASK
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

    ;; HELPER SUBROUTINES
    .include "engine/drawsprite.asm"
    .include "engine/readController.asm"
    .include "engine/renderMap.asm"
    ;;;;;;;;;;;;;;;;;;;;;;

    .bank 1
    .org $E000

palette:
  .db $30,$37,$16,$27,  $22,$16,$17,$0F,  $22,$30,$21,$0F,  $22,$27,$17,$0F   ;;background palette
  .db $30,$1E,$16,$27,  $22,$02,$38,$3C,  $22,$1C,$15,$14,  $22,$02,$38,$3C   ;;sprite palette

    .include "maps/tileset.asm"
    .include "maps/map00.asm"
    .include "sprites/sprites.asm"

    .org $FFFA

    .dw NMI
    .dw RESET
    .dw 0

    ;;;;;;;;;;;;;;;;;;;;;

    .bank 2             ; import graphics
    .org $0000
    .incbin "graphics/bank.chr"