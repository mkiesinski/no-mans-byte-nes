GameEngine:
    LDA gamestate
    CMP #STATEOVERWORLDINIT
    BEQ EngineOverworldInit

    LDA gamestate
    CMP #STATEOVERWORLD
    BEQ EngineOverworld

GameEngineDone:

    ;; progres the frame
IncFrame:
    INC frame
    LDA frame
    CMP #$20        ; reset every 16 frames
    BNE IncFrameDone
    LDA #$00
    STA frame
IncFrameDone