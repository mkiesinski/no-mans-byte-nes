EngineOverworldInit:

    ;;;; load player in sprite slot $0200
    LDX #$00
LoadPlayerSpriteLoop:
    LDA playerSpriteInitial,x
    STA $0200,x
    INX
    CPX #PLAYERSPRITESIZE
    BNE LoadPlayerSpriteLoop

    ;;;; set the player attributes, the way he is facing and animation frame
    

    LDA #STATEOVERWORLD
    STA gamestate
    
    JMP GameEngineDone
    
EngineOverworld:
    JSR playerMove
    JSR updatePlayerPosition

    LDA frame
    AND #03
    BNE skipPlayerSpriteUpdate
    LDA playerInput
    BEQ skipPlayerSpriteUpdate
    JSR updatePlayerSprite
skipPlayerSpriteUpdate:

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

    LDA #WEST                        ; set up facing direction
    STA playerDirection

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

    LDA #EAST
    STA playerDirection

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

    LDA #SOUTH
    STA playerDirection

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

    LDA #NORTH
    STA playerDirection

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

updatePlayerPosition:
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
    ADC #$08
    STA $0207
    STA $020F
    RTS

updatePlayerSprite:
    ;;; update frame count
    LDA playerFrameCount
    CLC         ; clear carry
    ADC #$01    ; advance frame by one
    AND #$01    ; keep only the bit for the current animation index, we are using only 2 frames
    STA playerFrameCount    ; save the current frame count

    ;; one animation for now
playerFrameOne:
    BEQ playerFrameTwo
    LDA playerFrame
    CLC
    ADC #$04    ; increase index by 4, next set of sprites
    STA playerFrame
    JMP playerFrameDone
playerFrameTwo:
    LDA playerFrame
    SEC
    SBC #$04    ; decrease index by 4, previous set of sprites
    STA playerFrame
playerFrameDone:

playerRedrawSprite:
    ;; setup the sprites for player, at index $0200, we still should have the frame in the accumulator
    LDX #$04    ; 4 sprites to update
    LDY #$00    ; offset
playerRefreshFrame:
    STA $0201,y   ; store the frame
    CLC
    ADC #$01      ; increment to next sprite
    INY
    INY
    INY
    INY           ; increase Y by 4, sprite info is offset by 4 addresses
    DEX           ; one less sprite to load
    BNE playerRefreshFrame

    RTS