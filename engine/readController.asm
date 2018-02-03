ReadControler:
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016
    LDX #$08
ReadControllerLoop:
    LDA $4016
    LSR A
    ROL playerInput
    DEX
    BNE ReadControllerLoop
    RTS