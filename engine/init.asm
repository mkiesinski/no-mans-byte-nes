    LDA #$80            ; set initial position
    STA playerPosX
    STA playerPosY

    LDA #DOWN
    STA playerDirection     ; set player direction down

    LDA #STATE_OVERWORLD_INIT
    STA gamestate

    LDA #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
    STA PPUCTRL
    LDA #%00011110   ; enable sprites, enable background, no clipping on left side
    STA PPUMASK
    
Forever:
    JMP Forever