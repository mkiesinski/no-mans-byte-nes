loadEnemiesSub:
    LDY #$00

loadEnemiesLoop:
    LDA [enemyPointer],y
    STA enemies,y
    CMP #$FF                    ; check if type is EOS
    BEQ loadEnemiesDone

loadEnemyAttributesLoop
    LDX #$07
    INY
    LDA [enemyPointer],y
    STA enemies, y
    DEX
    CPX #$00
    BEQ loadEnemyAttributesLoop
    JMP loadEnemiesLoop
    
loadEnemiesDone:
    RTS

drawEnemies:
    LDA #LOW(enemies)
    STA enemyPointer
    LDA #HIGH(enemies)
    STA enemyPointer+1

    LDA #$10
    STA enemiesOffset

drawEnemiesLoop:
    LDY #$00
    LDA [enemyPointer],y
    CMP #$FF
    BEQ drawEnemiesDone

    LDA #$02
    STA rowsToDraw

    INY
    LDA [enemyPointer],y        ; load attribute
    STA spriteAttributes

    INY
    LDA [enemyPointer],y
    STA spriteX

    INY
    LDA [enemyPointer],y
    STA spriteY

    LDA #$00
    STA spriteDirection

    LDX #$00
    LDY enemiesOffset

drawEnemyLoop:
    LDA KnucklesGraphicsTable,x
    STA spriteTileFirst
    LDA KnucklesGraphicsTable+1,x
    JSR DrawOneSpriteRow
    DEC rowsToDraw
    BNE drawEnemyLoop

    LDA enemiesOffset
    CLC
    ADC #$10                ; offset to next enemy
    STA enemiesOffset

    LDA enemyPointer
    CLC
    ADC #$04
    STA enemyPointer
    LDA enemyPointer+1
    ADC #$00
    STA enemyPointer+1

    JMP drawEnemiesLoop

drawEnemiesDone:
    RTS