EngineOverworldInit:

    ;;;; load player in sprite slot $0200
    LDX #$00
LoadPlayerSpriteLoop:
    LDA playerSprite,x
    STA $0200,x
    INX
    CPX #PLAYERSPRITESIZE
    BNE LoadPlayerSpriteLoop

    LDA #STATEOVERWORLD
    STA gamestate
    
    JMP GameEngineDone
    
EngineOverworld:
overworldRight:
    LDA playerInput
    AND #BUTTONRIGHT
    BEQ overworldRightDone
    LDA $0203
    CLC
    ADC #$01
    STA $0203
overworldRightDone:
    JMP GameEngineDone