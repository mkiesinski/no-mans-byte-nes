processPlayer:

playerMoveRight:
    LDA playerInput                 ; Load player input from variable
    AND #BUTTONRIGHT                ; remove all bits except the RIGHT button bit
    CMP #BUTTONRIGHT                ; check if RIGHT button is pressed (is 1)
    BNE playerMoveRightDone         ; if RIGHT not pressed (is 0), skip move logic

    LDA playerPosX                  ; update player position
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

DrawPlayer:
    LDA #$02
    STA rowsToDraw
    LDA playerPosX
    STA spriteX
    LDA playerPosY
    STA spriteY
    LDA playerFlip
    STA spriteFlipControl
    LDA playerAttributes
    STA spriteAttributes
    LDX playerFrameControl
    LDY #PLAYER_SPRDATA_OFFSET

DrawPlayerLoop:
    LDA PlayerGraphicsTable,x
    STA spriteTileFirst
    LDA PlayerGraphicsTable+1,x
    JSR DrawOneSpriteRow
    DEC rowsToDraw
    BNE DrawPlayerLoop 