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

    LDA playerPosX                  ; update player position
    CLC
    ADC #PLAYERSPEED
    STA playerPosX

    LDA playerDirection             ; load current facing direction
    CMP #WEST
    BEQ playerMoveRightAnimation     ; if we already face WEST, skip to animation

    LDA PLAYERWESTANIMATION         ; set animation to moving WEST
    STA playerFrame
    LDA #WEST                        ; set up facing direction
    STA playerDirection

playerMoveRightAnimation:            ; animation logic
    LDA frame
    AND #07                          ; update every 8 frames
    BNE playerMoveRightDone          ; skip rest if not updating

    JSR playerAdvanceFrame

    BEQ playerMoveRightFrameReset
    LDA playerFrame
    CLC
    ADC #$04
    STA playerFrame
    JMP playerMoveRightDone
playerMoveRightFrameReset:
    LDA PLAYERWESTANIMATION
    STA playerFrame

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

    LDA playerDirection             ; load current facing direction
    CMP #EAST
    BEQ playerMoveLeftAnimation     ; if we already face WEST, skip to animation

    LDA PLAYEREASTANIMATION         ; set animation to moving WEST
    STA playerFrame
    LDA #EAST                        ; set up facing direction
    STA playerDirection

playerMoveLeftAnimation:            ; animation logic
    LDA frame
    AND #07                          ; update every 8 frames
    BNE playerMoveLeftDone          ; skip rest if not updating

    JSR playerAdvanceFrame

    BEQ playerMoveLeftFrameReset
    LDA playerFrame
    CLC
    ADC #$04
    STA playerFrame
    JMP playerMoveLeftDone
playerMoveLeftFrameReset:
    LDA PLAYEREASTANIMATION
    STA playerFrame

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

    LDA playerDirection             ; load current facing direction
    CMP #SOUTH
    BEQ playerMoveDownAnimation     ; if we already face WEST, skip to animation

    LDA PLAYERSOUTHANIMATION         ; set animation to moving WEST
    STA playerFrame
    LDA #SOUTH                       ; set up facing direction
    STA playerDirection

playerMoveDownAnimation:            ; animation logic
    LDA frame
    AND #07                          ; update every 8 frames
    BNE playerMoveDownDone          ; skip rest if not updating

    JSR playerAdvanceFrame

    BEQ playerMoveDownFrameReset
    LDA playerFrame
    CLC
    ADC #$04
    STA playerFrame
    JMP playerMoveDownDone
playerMoveDownFrameReset:
    LDA PLAYERSOUTHANIMATION
    STA playerFrame

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

    LDA playerDirection             ; load current facing direction
    CMP #NORTH
    BEQ playerMoveUpAnimation     ; if we already face WEST, skip to animation

    LDA PLAYERNORTHANIMATION         ; set animation to moving WEST
    STA playerFrame
    LDA #NORTH                        ; set up facing direction
    STA playerDirection

playerMoveUpAnimation:            ; animation logic
    LDA frame
    AND #07                          ; update every 8 frames
    BNE playerMoveUpDone          ; skip rest if not updating

    JSR playerAdvanceFrame

    BEQ playerMoveUpFrameReset
    LDA playerFrame
    CLC
    ADC #$04
    STA playerFrame
    JMP playerMoveUpDone
playerMoveUpFrameReset:
    LDA PLAYERNORTHANIMATION
    STA playerFrame    

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
    ;; Update the position of the sprite
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

    ;; setup the sprites for player, at index $0200
    LDA playerFrame
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

playerAdvanceFrame:
    LDA playerFrameCount    ; load frame count    
    CLC                     ; clear carry
    ADC #$01                ; advance frame by one
    AND #$01                ; keep only the bit for the current animation index, we are using only 2 frames
    STA playerFrameCount    ; save the current frame count
    RTS