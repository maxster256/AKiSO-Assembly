.data

.balign 4
message1: .asciz "Welcome to GCD finder for ARM\n"

.balign 4
message2: .asciz "Enter first number: "

.balign 4
message3: .asciz "Enter second number: "

.balign 4
message4: .asciz "GCD(%d, %d) = %d\n"

.balign 4
format: .asciz "%d"

.balign 4
number1: .word 0

.balign 4
number2: .word 0

.balign 4
return: .word 0

.text
.global main

main:
			ldr r1, addr_of_return
			str lr, [r1]

			ldr r0, addr_of_message1
			bl printf
			ldr r0, addr_of_message2
			bl printf
			ldr r0, addr_of_format
			ldr r1, addr_of_number1
			bl scanf
			ldr r0, addr_of_message3
			bl printf
			ldr r0, addr_of_format
			ldr r1, addr_of_number2
			bl scanf

			ldr r2, addr_of_number1
			ldr r2,[r2]
			ldr r3, addr_of_number2
			ldr r3,[r3]
gcd:
			cmp r2,r3
			subgt r2,r2,r3
			sublt r3,r3,r2
			bne    gcd

			ldr r0, addr_of_message4
			ldr r1, addr_of_number1
			ldr r1,[r1]
			ldr r2, addr_of_number2
			ldr r2,[r2]
			bl printf

			ldr lr, addr_of_return
			ldr lr, [lr]
			bx lr

			addr_of_number1 : .word number1
			addr_of_number2 : .word number2
			addr_of_message1 : .word message1
			addr_of_message2 : .word message2
			addr_of_message3 : .word message3
			addr_of_message4 : .word message4
			addr_of_format : .word format
			addr_of_return : .word return

			.global printf
			.global scanf
