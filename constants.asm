;; CONSTANTS
;;; ENGINE
LASTFRAME = $0F

;;; STATES
STATEOVERWORLDINIT  = $01
STATEOVERWORLD    = $02

;;; BUTTONS
BUTTONRIGHT     = $01
BUTTONLEFT      = $02
BUTTONDOWN      = $04
BUTTONUP        = $08
BUTTONSTART     = $10
BUTTONSELECT    = $20
BUTTONB         = $40
BUTTONA         = $80

;;; GENERAL
NORTH           = $00
WEST            = $01
SOUTH           = $02
EAST            = $03

;;; PLAYER VARS
PLAYERSPRITESIZE  = $10     ; each sprite has 4 values (Y,Sprite,Pallete,X) and player is built of 4 sprites
PLAYERSPEED       = $02     ; speed of the player
PLAYERSOUTHANIMATION = $00  ; address for animation moving south