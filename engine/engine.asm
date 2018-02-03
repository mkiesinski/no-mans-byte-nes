GameEngine:
    LDA gamestate
    CMP #STATEOVERWORLDINIT
    BEQ EngineOverworldInit

    LDA gamestate
    CMP #STATEOVERWORLD
    BEQ EngineOverworld

GameEngineDone: