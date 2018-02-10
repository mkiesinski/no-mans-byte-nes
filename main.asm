    .inesprg 4          ; 4x 16KB PRG = 128KB PRG
    .ineschr 0          ; 0x 8KB CHR
    .inesmap 1          ; MMC1 mapper
    .inesmir %10

    .include "nes_constants.asm"
    .include "constants.asm"

    .rsset $0000
    .include "variables.asm"

    .bank 0
    .org $8000
    .include "maps/map00.asm"

    .bank 1
    .org $A000

    .bank 2
    .org $8000

    .bank 3
    .org $A000

    .bank 4
    .org $8000

    .bank 5
    .org $A000

    .bank 6
    .org $C000
    Graphics:
    .incbin "graphics/bank.chr"

    .bank 7
    .org $E000
    ;; subroutines
    .include "init_helper.asm"
    .include "engine/readController.asm"
    .include "engine/drawsprite.asm"
    .include "engine/renderMap.asm"
    .include "engine/renderPlayer.asm"
    .include "engine/renderEnemies.asm"

    ;; START
    .include "init.asm"
    .include "engine/init.asm"

NMI
    .include "engine/engine.asm"

    RTI

    .include "engine/overworld.asm"

palette:
    .db $30,$37,$16,$27,  $22,$16,$17,$0F,  $22,$30,$21,$0F,  $22,$27,$17,$0F   ;;background palette
    .db $30,$1E,$16,$27,  $30,$0F,$16,$30,  $22,$1C,$15,$14,  $22,$02,$38,$3C   ;;sprite palette

    .include "maps/tileset.asm"
    .include "sprites/sprites.asm"

    .org $FFFA

    .dw NMI
    .dw RESET
    .dw 0