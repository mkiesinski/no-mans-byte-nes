VBlankWait:              ; wait for vblank
    BIT PPUSTATUS
    BPL VBlankWait
    RTS

ConfigWrite:
    LDA #$80
    STA $8000

    LDA #%00001110      ; 8KB CHR, 16KB PRG, $8000-BFFF swappable, vertical mirroring
    STA $8000           ; first data bit
    LSR A               ; shift to next bit
    STA $8000           ; second data bit
    LSR A               ; etc
    STA $8000
    LSR A
    STA $8000
    LSR A
    STA $8000
    RTS

PRGBankWrite:
    LDA sourceBank      ; load bank number

    AND #%01111111      ; clear the WRAM bit so it is always enabled

    STA $E000
    LSR A
    STA $E000
    LSR A
    STA $E000
    LSR A
    STA $E000
    LSR A
    STA $E000
    RTS

LoadCHRAM:
    LDA PPUSTATUS
    LDA #$00
    STA PPUADDR         ; set PPU to the CHR RAM area $0000-1FFFF
    STA PPUADDR
    LDY #$00
    LDX #$20
    LDA #LOW(Graphics)
    STA source
    LDA #HIGH(Graphics)
    STA source+1
LoadCHRAMLoop:
    LDA [source], y
    STA PPUDATA
    INY
    BNE LoadCHRAMLoop
    INC source+1
    DEX
    BNE LoadCHRAMLoop
LoadCHRAMDone:
    RTS

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
    RTS