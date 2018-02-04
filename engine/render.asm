DrawPlayer:
    LDA #$02
    STA rowsToDraw
    LDA playerPosX
    STA spriteX
    LDA playerPosY
    STA spriteY
    LDA playerDirection
    STA spriteDirection
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