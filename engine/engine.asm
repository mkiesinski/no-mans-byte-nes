GameEngine:
    LDA gamestate
    CMP #STATEOVERWORLD
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

    .include "engine/render"