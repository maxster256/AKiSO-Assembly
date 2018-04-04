global	main
extern	printf

section	.text
main:
			mov eax, 2			; sets p = 2
			mov esi, 3			; sets q = 3
			mov edi, 0			; clears esi for use later
			;push esi				; push q to the stack
			;push eax				; push p to the stack
			;push format			; set the print format
			;call printf			; print

			;add esp, 4 			; remove format from stack
			;add esp, 4

			;add eax, 2			; sets p = 5
			;mov esi, 2			; sets q = 7
			jmp cnd					; skok do warunku

nextnum:
			; increasing numbers by 2
			add esi, 2			; q = q + 2

cnd:
			cmp esi, 10000
			jl setdiv				; if q < 10000 go to setdiv
			ret							;	else end the program

setdiv:
			mov ebx, 2 			; sets divisor = 2

nextdiv:
			;	modulo
			; if (q % i == 2)
			mov edx, 0		; wynik dzielenia jest przechowywany w eax, reszta w edx
			push eax			; odkladamy p na stos (dzielenie nadpisze p)
			mov eax, esi  ; na eax przenosimy q
			idiv ebx			; wykonujemy dzielenie z reszta przez dzielnik
			pop eax				; przywracamy nasze p na eax
			cmp edx, 0		; sprawdzamy czy reszta to 0
			je nextnum 		; jesli tak przechodzimy do nastepnej liczby - ta nie byla pierwsza

			add ebx, 1		; jesli nie, inkrementujemy dzielnik

			mov ecx, ebx	; sprawdzamy tylko dla dzielnikow nie wiekszych od pierwiastka z liczby
			imul ecx, ebx	; wiec w ecx ustawiamy kwadrat dzielnika
			cmp ecx, esi	; i sprawdzamy czy jest mniejszy od liczby q
			jle nextdiv		; jesli tak sprawdzamy kolejny dzielnik

			;push esi
			;push eax
			;push faux
			;call printf

			;add esp, 4 			; remove format from stack

			; jesli wyszlismy z petli sprawdzamy drugi warunek (q - prime)
			mov edi, 0
			mov edi, esi  ; ecx = q;
			sub edi, eax  ; ecx = q - p;

			mov ecx, 0
			mov ecx, eax  ; store old p in ecx
			mov eax, 0
			add eax, esi  ; p = q (for use later)

			cmp edi, 2
			jne nextnum   ; jesli warunek nie spelniony, to nie jest para

			push esi			; jesli jest
			push ecx
			push pair_print
			call printf
			add esp,4 	; usuwamy message ze stosu

			pop eax
			pop ecx

			jmp nextnum	;	przechodzimy do kolejnej liczby

pair_print:
			; db - zadeklarowanie i zainicjowanie 1 bajta w pamięci, czyli w message 4 (%, d, 10 - \n, 0 - null)
			db "%d, %d", 10, 0
