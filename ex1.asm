				ORG $1000

START		EQU *
				LDA <TEXT				; loads to AC
				STA $80					; stores accumulator contents in ZERO PAGE, 80
				LDA >TEXT
				STA $81
				LDY #1
				LDA #%11110001  ; number to convert from BIN to HEX
				JSR PHEX

				LDA <TEXT
				LDX >TEXT
				JSR $FF80				; that's what makes stuff appear on the screen
				BRK

PHEX    PHA             ; pushes a copy of the accumulator onto the stack
        JSR PXDIG       ; pushes the adress (minus one) of the return point onto the stack and sets PC to target mem adress
        PLA             ; pulls an 8-bit value from the stack into the accumulator; zero and negative flags are set (N if bit 7 of A is set)
        LSR @           ; logical shift to the right
        LSR @           ; - meaning: shift all the bits one position to the right
        LSR @           ; - the least significant bit is shifted into the carry flag
        LSR @

PXDIG   AND #%00001111  ; logical AND (A&M), performed bit by bit on A using a byte of memory
        ORA #'0'        ; ORA - logical inclusive OR (A|M) performed on A using a byte of memory
        CMP #'9'+1      ; Compares content of A with value and sets zero (if A = M) and carry flags (if A >= M)
        BCC PR          ; Branch if Carry Clear (to a new location provided)
        ADC #'A'-'9'-2  ; ADd with Carry - if overflow occurs, carry bit is set
PR      STA ($80),Y     ; store accumulator - stores the contents of the accumulator into memory
        DEY             ; decrements Y register by 1 (Y - 1)
        RTS             ; return from subroutine

TEXT		EQU *
				DTA B(0),B(0)
				DTA B(10)
				DTA B(0)

				ORG $2E0
				DTA A(START)

				end of file
