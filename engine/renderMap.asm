renderMapSub:
    
background_start:
    LDA repeatMetaTile
    BEQ .jump
    DEC repeatMetaTile
    JMP decompress

.jump
    LDY data_y
    LDA [mapPointer],y
    CMP #$FF
    BNE .next
    JMP background_complete
.next
    LDA [mapPointer],y
    AND #%10000000
    BNE .next1
    JMP .loadtile
.next1
    LDA [mapPointer],y
    AND #%01000000
    BNE .next2
    JMP .repeat
.next2
    LDA [mapPointer],y
    AND #%00111111
    ASL A
    TAX

    LDA meta_tile_sets,x
    STA metaTilesetPointer
    LDA meta_tile_sets+1,x
    STA metaTilesetPointer+1
    INY
    STY data_y
    JMP background_start

.repeat
    LDA [mapPointer],y
    AND #%00111111
    STA repeatMetaTile
    INY
    STY data_y

.loadtile
    LDA [mapPointer],y
    INY
    STY data_y
    ASL A
    TAY

    LDA [metaTilesetPointer],y
    STA metaTilePointer
    INY
    LDA [metaTilesetPointer],y
    STA metaTilePointer+1

decompress:
    LDY #$00
    LDX data_x
    LDA [metaTilePointer],y
    STA PPUDATA
    INY
    LDA [metaTilePointer],y
    STA PPUDATA
    INY
    LDA [metaTilePointer],y
    STA background_row,x
    INY
    INX
    LDA [metaTilePointer],y
    STA background_row,x
    INX
    STX data_x
    CPX #$20
    BEQ .next
    JMP background_start

.next
    LDY #$00
row_start:
    LDA background_row,y
    STA PPUDATA
    INY
    CPY #$20
    BNE row_start
    LDX #$00
    STX data_x
    JMP background_start

background_complete:
    RTS