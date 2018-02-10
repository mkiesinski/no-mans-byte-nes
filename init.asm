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

    JSR ConfigWrite

    LDA #$00
    STA sourceBank
    JSR PRGBankWrite        ; do switch Bank switch to enable WRAM

clrmem:
    LDA #$00
    STA $0000, x
    STA $0100, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x

    STA $6000, x
    STA $6100, x
    STA $6200, x
    STA $6300, x
    STA $6400, x

    LDA #$FE
    STA $0200, x
    INX
    BNE clrmem

    JSR VBlankWait

;; Load graphics information
    LDA #$00
    STA palleteID
    JSR LoadCHRAM
    JSR LoadPalettes