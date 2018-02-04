ReadControler:
    LDA #$01
    STA JOYPAD1
    LDA #$00
    STA JOYPAD1
    LDX #$08
ReadControllerLoop:
    LDA JOYPAD1
    LSR A
    ROL playerInput
    DEX
    BNE ReadControllerLoop
    RTS