processPlayer:

    INC playerFrame
    LDA playerFrame
    CMP #$08        ; reset every 8 frames
    BNE IncPlayerFrameDone
    LDA #$00
    STA playerFrame
IncPlayerFrameDone:

playerMoveRight:
    LDA playerInput                 ; Load player input from variable
    AND #BUTTONRIGHT                ; remove all bits except the RIGHT button bit
    CMP #BUTTONRIGHT                ; check if RIGHT button is pressed (is 1)
    BNE playerMoveRightDone         ; if RIGHT not pressed (is 0), skip move logic

    LDA playerPosX                  ; update player position
    CLC
    ADC #PLAYERSPEED
    STA playerPosX

    LDA playerDirection
    CMP #RIGHT
    BEQ playerMoveRightUpdateFrame

    LDA #RIGHT
    STA playerDirection
    LDA #$10                        ; frame 0 of walking right animation
    STA playerFrameControl          ; store in the frame control
    JMP playerMoveRightReturn        ; done

playerMoveRightUpdateFrame:
    LDA playerFrame
    CMP #$04
    BNE playerMoveRightReturn

    LDA #$14                        ; max frame
    STA maxFrame                    ; store to max Frame memory, we do this to keep Accumulator 
    LDX #$10                        ; frame 0 of walking right animation
    JSR PlayerGetNextFrame          ; execute getting new frame
playerMoveRightReturn
    JMP processPlayerDone
playerMoveRightDone:

playerMoveLeft:                 
    LDA playerInput             
    AND #BUTTONLEFT  
    CMP #BUTTONLEFT                     
    BNE playerMoveLeftDone

    LDA playerPosX
    SEC
    SBC #PLAYERSPEED
    STA playerPosX

    LDA playerDirection
    CMP #LEFT
    BEQ playerMoveLeftUpdateFrame

    LDA #LEFT
    STA playerDirection
    LDA #$10                        ; frame 0 of walking right animation
    STA playerFrameControl          ; store in the frame control
    JMP playerMoveLeftReturn        ; done

playerMoveLeftUpdateFrame:
    LDA playerFrame
    CMP #$04
    BNE playerMoveLeftReturn

    LDA #$14                        ; max frame
    STA maxFrame                    ; store to max Frame memory, we do this to keep Accumulator 
    LDX #$10                        ; frame 0 of walking right animation
    JSR PlayerGetNextFrame          ; execute getting new frame    

playerMoveLeftReturn:
    JMP processPlayerDone
playerMoveLeftDone:

playerMoveDown:
    LDA playerInput
    AND #BUTTONDOWN
    CMP #BUTTONDOWN                   
    BNE playerMoveDownDone

    LDA playerPosY
    CLC
    ADC #PLAYERSPEED
    STA playerPosY

    LDA playerDirection
    CMP #DOWN
    BEQ playerMoveDownUpdateFrame

    LDA #DOWN
    STA playerDirection
    LDA #$00                        ; frame 0 of walking down animation
    STA playerFrameControl          ; store in the frame control
    JMP playerMoveDownReturn         ; done

playerMoveDownUpdateFrame:
    LDA playerFrame
    CMP #$04
    BNE playerMoveDownReturn

    LDA #$04                        ; max frame
    STA maxFrame                    ; store to max Frame memory, we do this to keep Accumulator 
    LDX #$00                        ; frame 0 of walking down animation
    JSR PlayerGetNextFrame          ; execute getting new frame  

playerMoveDownReturn:
    JMP processPlayerDone
playerMoveDownDone:

playerMoveUp:
    LDA playerInput
    AND #BUTTONUP 
    CMP #BUTTONUP
    BNE playerMoveUpDone

    LDA playerPosY
    SEC
    SBC #PLAYERSPEED
    STA playerPosY

    LDA playerDirection
    CMP #UP
    BEQ playerMoveUpUpdateFrame

    LDA #UP
    STA playerDirection
    LDA #$08                        ; frame 0 of walking down animation
    STA playerFrameControl          ; store in the frame control
    JMP playerMoveUpReturn            ; done

playerMoveUpUpdateFrame:
    LDA playerFrame
    CMP #$04
    BNE playerMoveUpReturn

    LDA #$0C                        ; max frame
    STA maxFrame                    ; store to max Frame memory, we do this to keep Accumulator 
    LDX #$08                        ; frame 0 of walking down animation
    JSR PlayerGetNextFrame          ; execute getting new frame    
playerMoveUpReturn:
    JMP processPlayerDone
playerMoveUpDone:

playerStart:
    LDA playerInput
    AND #BUTTONSTART 
    CMP #BUTTONSTART
    BNE playerStartDone

playerStartReturn:
    JMP processPlayerDone
playerStartDone:

playerSelect:
    LDA playerInput
    AND #BUTTONSELECT
    CMP #BUTTONSELECT
    BNE playerSelectDone

playerSelectReturn:
    JMP processPlayerDone
playerSelectDone:

playerB:
    LDA playerInput
    AND #BUTTONB
    CMP #BUTTONB
    BNE playerBDone

playerBReturn:
    JMP processPlayerDone
playerBDone:

playerA:
    LDA playerInput
    AND #BUTTONA
    CMP #BUTTONA
    BNE playerADone

playerAReturn:
    JMP processPlayerDone
playerADone:

    JMP processPlayerDone

PlayerGetNextFrame:
    LDA playerFrameControl          ; Load the current Frame
    CMP maxFrame
    BEQ PlayerGetNextFrameReset
    CLC
    ADC #$04
    JMP PlayerGetNextFrameDone
PlayerGetNextFrameReset:
    TXA
PlayerGetNextFrameDone:
    STA playerFrameControl          ; store the next frame
    RTS

processPlayerDone: