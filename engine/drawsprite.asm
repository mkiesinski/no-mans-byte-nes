DrawOneSpriteRow:
    STA spriteTileSecnd
    JMP DrawSpriteObject

DrawSpriteObject:
    LDA spriteDirection        ; get flip control bits
    LSR A
    LSR A                        ; move d1 into carry
    LDA spriteTileFirst
    BCC NoHFlip                 ; if d1 not set, branch
    STA SPRITE_TILENUMBER+4,y   ;
    LDA spriteTileSecnd         ;
    STA SPRITE_TILENUMBER,y
    LDA #$40
    BNE SetHFAt
NoHFlip:
    STA SPRITE_TILENUMBER,y
    LDA spriteTileSecnd
    STA SPRITE_TILENUMBER+4,y
    LDA #$00
SetHFAt:
    ORA spriteAttributes
    STA SPRITE_ATTRIBUTES,y
    STA SPRITE_ATTRIBUTES+4,y
    LDA spriteY
    STA SPRITE_Y_POSITION,y
    STA SPRITE_Y_POSITION+4,y
    LDA spriteX
    STA SPRITE_X_POSITION,y
    CLC
    ADC #$08
    STA SPRITE_X_POSITION+4,y
    LDA spriteY
    CLC
    ADC #$08
    STA $02
    TYA
    CLC
    ADC #$08
    TAY
    INX
    INX
    RTS