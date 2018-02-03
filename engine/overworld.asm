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
    JSR playerMove
    JSR updatePlayerSprite

    JMP GameEngineDone

;;; PLAYER MOVEMENT LOGIC

playerMove:

playerMoveRight:
    LDA playerInput                 ; Load player input from variable
    AND #BUTTONRIGHT                ; remove all bits except the RIGHT button bit
    CMP #BUTTONRIGHT                ; check if RIGHT button is pressed (is 1)
    BNE playerMoveRightDone         ; if RIGHT not pressed (is 0), skip move logic

    LDA playerPosX
    CLC
    ADC #PLAYERSPEED
    STA playerPosX

playerMoveRightDone:

playerMoveLeft:                 
    LDA playerInput             
    AND #BUTTONLEFT  
    CMP #BUTTONLEFT                     
    BNE playerMoveLeftDone

    LDA playerPosX
    SEC
    SBC #PLAYERSPEED
    STA playerPosX

playerMoveLeftDone:

playerMoveDown:
    LDA playerInput
    AND #BUTTONDOWN
    CMP #BUTTONDOWN                   
    BNE playerMoveDownDone

    LDA playerPosY
    CLC
    ADC #PLAYERSPEED
    STA playerPosY

playerMoveDownDone:

playerMoveUp:
    LDA playerInput
    AND #BUTTONUP 
    CMP #BUTTONUP
    BNE playerMoveUpDone

    LDA playerPosY
    SEC
    SBC #PLAYERSPEED
    STA playerPosY

playerMoveUpDone:

playerStart:
    LDA playerInput
    AND #BUTTONSTART 
    CMP #BUTTONSTART
    BNE playerStartDone

playerStartDone:

playerSelect:
    LDA playerInput
    AND #BUTTONSELECT
    CMP #BUTTONSELECT
    BNE playerSelectDone

playerSelectDone:

playerB:
    LDA playerInput
    AND #BUTTONB
    CMP #BUTTONB
    BNE playerBDone

playerBDone:

playerA:
    LDA playerInput
    AND #BUTTONA
    CMP #BUTTONA
    BNE playerADone

playerADone:

    RTS

updatePlayerSprite:
    LDA playerPosY
    STA $0200
    STA $0204
    CLC
    ADC #$08
    STA $0208
    STA $020C

    LDA playerPosX
    STA $0203
    STA $020B
    CLC
    ADC #08
    STA $0207
    STA $020F
    RTS