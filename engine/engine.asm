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

    ;; graphic updates end here
    
    JSR ReadControler

GameEngine:
    LDA gamestate

    CMP #STATE_OVERWORLD_INIT
    BEQ EngineOverworldInit

    CMP #STATE_OVERWORLD
    BEQ EngineOverworld

GameEngineDone:

    ;; progres the frame
IncFrame:
    INC frame
    LDA frame
    CMP #$10        ; reset every 16 frames
    BNE IncFrameDone
    LDA #$00
    STA frame
IncFrameDone: