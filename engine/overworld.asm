EngineOverworldInit:
    LDA #$00
    STA PPUCTRL             ; disable NMI for the rendering
    STA PPUMASK             ; disable rendering
    STA APU_MODCTRL         ; disable DMC IRQs

    LDA #LOW(map00)     ; load the initial map pointer
    STA mapPointer
    LDA #HIGH(map00)
    STA mapPointer+1

    LDA PPUSTATUS            ; read PPU status to reset the high/low latch
    LDA #$20
    STA PPUADDR             ; write the high byte of $2000 address
    LDA #$00
    STA PPUADDR             ; write the low byte of $2000 address

    JSR renderMapSub        ; render map

    LDA #STATE_OVERWORLD     ; set state
    STA gamestate

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PPUCTRL
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA PPUMASK

    JMP GameEngineDone      ; done

EngineOverworld:
    .include "engine/player.asm"
    .include "engine/renderPlayer.asm"
    JMP GameEngineDone