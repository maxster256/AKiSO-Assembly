            OPT f-g-h+l+o+
            ORG $1000

START       EQU *

            LDA #$AA    ; loads number for conversion into the accumulator
            STA BYTE    ; store loaded number in BYTE

            LDA #0      ; loads 0 into the accumulator
            LDX #8      ; loads into the X registry the number of bits in the digit
            SED         ; sets Decimal Mode Flag to 1 (decimal mode)

BCD         ASL BYTE    ; shifts one bit left (bit 0 = 0, carry flag = bit 7), aka multiply by 2
            LDA WORD    ; loads word into the accumulator
            ADC WORD    ; adds (with carry) AC = AC + WORD + C (and sets C = bit 7 if overflow occurs)
            STA WORD	  ; sets WORD = AC
            ROL WORD+1	; moves each bit in WORD+1 one place to the left (bit 0 = carry flag, carry flag = bit 7)
            DEX			    ; decrements registry X by 1
            BNE BCD     ; if Z clear goto BCD (zero flag is set if the result of last operation was zero)

            CLD         ; clear decimal mode, sets D to 0

            LDA WORD+1  ; prints the second digit of the old byte
            JSR PRINT

            LDA WORD    ; prints the first digit of the younger byte
            LSR @
            LSR @       ; logical shift to the right
            LSR @       ; - meaning: shift all the bits in AC one position to the right
            LSR @       ; - the least significant bit is shifted into the carry flag
            JSR print

            LDA WORD    ; prints the second digit of the younger byte
            JSR print

            BRK

PRINT       AND #$f
            ORA #'0'
            STA CHAR
            LDA <char
            LDX >char
            JSR $ff80
            RTS

            ORG $2000

CHAR        DTA B(0)
BYTE        DTA B(0)
WORD        DTA B(0)
            DTA B(0)

            ORG $2E0
            DTA A(START)

            end of file
