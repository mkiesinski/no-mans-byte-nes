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