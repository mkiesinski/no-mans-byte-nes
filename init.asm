VBlankWait:              ; wait for vblank
    BIT $2002
    BPL VBlankWait
    RTS

RESET:
    SEI                 ; disable IRQs
    CLD                 ; disable decimal
    LDX #$40
    STX $4017    ; disable APU frame IRQ
    LDX #$FF
    TXS          ; Set up stack
    INX          ; now X = 0
    STX PPUCTRL  ; disable NMI
    STX PPUMASK  ; disable rendering
    STX APU_MODCTRL   ; disable DMC IRQs

    JSR VBlankWait

clrmem:
    LDA #$00
    STA $0000, x
    STA $0100, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x
    LDA #$FE
    STA $0200, x
    INX
    BNE clrmem

    JSR VBlankWait

LoadPalettes:
    LDA PPUSTATUS       ; read PPU to reset h/l latch
    LDA #$3F
    STA PPUADDR       ; write high byte of $3F00
    LDA #$00
    STA PPUADDR       ; write low byte of $3F00
    
    LDX #$00                ; set X to 0
LoadPalletesLoop:
    LDA palette, x          ; load pallete at index X
    STA PPUDATA               ; write the value to PPU
    INX                     ; increment X
    CPX #$20                ; check if X is 32
    BNE LoadPalletesLoop    ; if not, go to the start of the loop