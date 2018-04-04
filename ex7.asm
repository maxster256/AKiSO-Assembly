; Allow the linker to find the _start symbol. The linker will begin program execution
; there.
global _start
extern	printf

; Start the .data section of the executable, which stores constants (read-only data)
; It doesn't matter which order your sections are in, I just like putting .data first
section .rodata
    ; Declare some bytes at a symbol called error_msg. NASM's db pseudo-instruction
    ; allows either a single byte value, a constant string, or a combination of the two
    ; as seen here. 0xA = new line, and 0x0 = string-terminating null
    error_msg: db "Invalid input", 0xA, 0x0


; Start the .data section, which stores variable data
section .data
    stack_size: dd 0        ; create a dword (4-byte) variable set to zero
    stack: times 256 dd 0   ; fill the stack with 256 dword zeroes

; Start the .text section, which stores program code
_start:
    ; you do not get the arguments of _start the same way you do in other functions.
    ; instead, esp points directly to argc (the number of arguments), and esp+4 points
    ; to argv. Therefore, esp+4 points to the name of your program, esp+8 points to
    ; the first argument, etc
    mov esi, [esp+8]         ; esi = "input" = argv[0]
    ; call _strlen to find the length of the input
    push esi
    call _strlen
    mov ebx, eax             ; ebx = input_length
    add esp, 4
    ; end _strlen call
    mov ecx, 0               ; ecx = "i"
_main_loop_start:
    cmp ecx, ebx             ; if (i >= input_length)
    jge _main_loop_end
    mov edx, 0
    mov dl, [esi + ecx]      ; load only a byte from memory into the lower byte of
                             ; edx. We set the rest of edx to zero.
                             ; edx = c variable = input[i]
    cmp edx, '0'
    jl _check_operator
    cmp edx, '9'
    jg _print_error
    sub edx, '0'
    mov eax, edx             ; eax = c variable - '0' (the numeric digit, not char)
    jmp _push_eax_and_continue
_check_operator:
    ; call _pop twice to pop b into edi and a into eax
    push ecx
    push ebx
    call _pop
    mov edi, eax             ; edi = b
    call _pop                ; eax = a
    pop ebx
    pop ecx
    ; end call _pop
    cmp edx, '+'
    jne _subtract
    add eax, edi                 ; eax = a+b
    jmp _push_eax_and_continue
_subtract:
    cmp edx, '-'
    jne _multiply
    sub eax, edi                 ; eax = a-b
    jmp _push_eax_and_continue
_multiply:
    cmp edx, '*'
    jne _divide
    imul eax, edi                ; eax = a*b
    jmp _push_eax_and_continue
_divide:
    cmp edx, '/'
    jne _print_error
    push edx                     ; save edx since we'll need to set it to 0 for idiv
    mov edx, 0
    idiv edi                     ; eax = a/b
    pop edx
    ; now we push eax and continue
_push_eax_and_continue:
    ; call _push
    push eax
    push ecx
    push edx
    push eax          ; arg1
    call _push
    add esp, 4
    pop edx
    pop ecx
    pop eax
    ; end call _push
    inc ecx
    jmp _main_loop_start
_main_loop_end:
    cmp byte [stack_size], 1      ; if (stack_size != 1) print error
    jne _print_error
    mov eax, [stack]
    push eax
    call _print_answer
    ; print a final newline
    push 0xA
    call _putc
    ; exit successfully
    mov eax, 0x01           ; 0x01 = exit()
    mov ebx, 0              ; 0 = no errors
    int 0x80                ; execution will end here
_print_error:
    push error_msg
    call printf
    add esp,4 	; usuwamy message ze stosu
    mov eax, 0x01
    mov ebx, 1
    int 0x80

%define MAX_DIGITS 10

_print_answer:
    enter 1, 0              ; we'll use 1 byte for "started" variable in C
    push ebx
    push edi
    push esi
    mov eax, [ebp+8]        ; our "a" argument
    cmp eax, 0              ; if the number is not negative, skip this if-statement
    push eax
    push _print_format
    call printf
    add esp,4 	; usuwamy message ze stosu
    ret

_pow_10:
    enter 0, 0
    mov ecx, [ebp+8]    ; set ecx (caller-saved) to function arg
    mov eax, 1          ; first power of 10 (10**0 = 1)
_pow_10_loop_start:
    cmp ecx, 0
    je _pow_10_loop_end
    imul eax, 10
    sub ecx, 1
    jmp _pow_10_loop_start
_pow_10_loop_end:
    leave
    ret

_mod:
    enter 0, 0
    push ebx
    mov edx, 0          ; explained below
    mov eax, [ebp+8]
    mov ebx, [ebp+12]
    idiv ebx            ; divides the 64-bit integer [edx:eax] by ebx. We only want to divide the
                        ; 32-bit integer eax, so we set edx to zero. The result of this division
                        ; is stored in eax, and the remainder is stored in edx
    mov eax, edx        ; return the modulus
    pop ebx
    leave
    ret

_putc:
    enter 0, 0
    mov eax, 0x04       ; write()
    mov ebx, 1          ; standard out
    lea ecx, [ebp+8]    ; the input character
    mov edx, 1          ; print only 1 character
    int 0x80
    leave
    ret

_push:
    enter 0, 0
    ; Save the callee-saved registers that I'll be using
    push eax
    push edx
    mov eax, [stack_size]
    mov edx, [ebp+8]
    mov [stack + 4*eax], edx   ; Insert the arg into the stack. We scale
                               ; by 4 because each dword is 4 bytes each
    inc dword [stack_size]      ; Add 1 to stack_size
    ; Restore the callee-saved registers we used
    pop edx
    pop eax
    leave
    ret

_pop:
    enter 0, 0
    ; Save the callee-saved registers
    dec dword [stack_size]              ; Subtract 1 from stack_size first
    mov eax, [stack_size]
    mov eax, [stack + 4*eax]     ; Set the number at the top of the stack to eax
    ; Here I'd restore the callee-saved registers, but I didn't save any
    leave
    ret

_print_msg:
    enter 0, 0
    ; My function begins here
    mov eax, 0x04       ; 0x04 = the write() syscall
    mov ebx, 0x1        ; 0x1 = standard output
    mov ecx, [ebp+8]    ; the string we want to print is the first argument of this function
    ; at this point we wish to set edx to the length of the string. time to call _strlen
    push eax            ; save the caller-saved registers (I choose to not save edx)
    push ecx
    push dword [ebp+8]  ; push _strlen's argument, the string argument to _print_msg. NASM
                        ; complains if you do not put a size directive here, and I'm not sure
                        ; why. Anyway, a pointer is a dword (4 bytes)
    call _strlen        ; eax is now equal to the length of the string
    mov edx, eax        ; move the length into edx where we wanted it
    add esp, 4          ; remove 4 bytes from the stack (one 4-byte char* argument)
    pop ecx             ; restore caller-saved registers
    pop eax
    ; we're done calling _strlen and setting up the syscall
    int 0x80
    leave
    ret


_strlen:
    enter 0, 0              ; save the previous frame's base pointer and adjust ebp
    ; Here I'd save the callee-saved registers, but I won't be modifying any
    ; My function begins here
    mov eax, 0              ; length = 0
    mov ecx, [ebp+8]        ; copy the function's first argument (pointer to the first character
                            ; of the string) into ecx (which is caller-saved, so no need to save it)
_strlen_loop_start:
    cmp byte [ecx], 0       ; dereference that pointer and compare it to null. Here we have to
                            ; explicitly mention it's a byte since the size of the pointer is
                            ; ambiguous (is it a 4 byte integer? 2? 1?). This is called called a
                            ; Size Directive
    je _strlen_loop_end     ; jump out of the loop if it is equal to null
    add eax, 1              ; add 1 to our return value
    add ecx, 1              ; increment to the next character in the string
    jmp _strlen_loop_start  ; jump back to the start
_strlen_loop_end:
    ; My function ends here. eax is equal to my function's return value
    ; Here I'd restore the callee-saved registers, but I didn't save any
    leave                   ; deallocate and restore the previous frame's base pointer
    ret

_print_format:
    			; db - zadeklarowanie i zainicjowanie 1 bajta w pamięci, czyli w message 4 (%, d, 10 - \n, 0 - null)
    			db "%d, %d", 10, 0
