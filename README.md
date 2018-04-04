# AKiSO-Assembly
Sixth list for the labs for the AKiSO course, where we've had to work on our assembly skills for various processors (MOS 6502, x86-32 + FPU, ARM)

## Glossary

### MOS 6502
- prosty procesor 8-bitowy
- 16-bitowa szyną adresowa, pozwalająca zaadresować do 64 kB
- architektura little-endian (adresy są zapisywane w pamięci począwszy od najmniej znaczącego bitu)

### x86
- 8 "ogólnych", 32-bitowych rejestrów {eax, ecx, edx, ebx, esp, ebp, esi, edi} (tak naprawdę ponad 100)
- 8 rejestrów 16-bitowych i 8 rejestrów 8-bitowych jako części rejestrów 32-bitowych
- rejestr eflags: carry (CF), overflow (OF), sign (SF), parity (PF), zero (ZF) ec
- kodowanie little-endian (najmniej znaczący bajt na początku)
￼
https://www.nayuki.io/page/a-fundamental-introduction-to-x86-assembly-programming

## Exercises

### Zadanie 1.
Wykorzystując program z wykładu, napisz program w asemblerze dla procesora 6502, który wyświetla na ekranie liczbę 8-bitową w kodzie szesnastkowym. Wytłumacz dokładnie zasadę jego działania. Pokaż jak program wykonuje się w emulatorze emu6502. Pokaż również jak można wykorzystać opcje -v oraz -m emulatora.

Pokrótce zasada działania:
- dzielimy liczbę na bajty
- korzystamy z algorytmu z wykładu
- wyświetlamy szesnastkowo pierwszy i drugi bajt

### Zadanie 2.
Wykorzystując program do konwersji BCD z wykładu, napisz program w asemblerze dla procesora 6502, który wyświetla na ekranie liczbę 8-bitową w kodzie dziesiętnym. Wytłumacz dokładnie zasadę jego działania.

Pokrótce zasada działania:
- robimy to właściwie tak, jakbyśmy zamieniali liczbę "na kartce"
- włączamy tryb dziesiętny, aby 0x05 + 0x05 = 0x10
- "skaczemy" po liczbie od lewej strony
- jeśli napotkamy jedynkę, to dodajemy to, co było +1
- a jak 0 to mnożymy razy 2, gdy po dodaniu będzie ustawione C, to znaczy że przeszło na setki i jest dodawane do Word+1 flaga c
- pytamy, czy była 1 czy 0, bo przesuwamy sobie wszystko w lewo, a to co zostało usunięte idzie  do flagi C

### Zadanie 5.
Napisz program w asemblerze x86 (32-bit), który wysyła na standardowe wyjście liczby bliźniacze mniejsze od 10 000.

Program realizuje algorytm zapisany w języku C:

int main() {
    for (int p = 2, q = 3; q < 10000; q += 2) {
        int is_prime = 1;

        for (int i = 2; i < sqrt(q); i++) {
            // Checks if q is prime
            if (q % i == 0) {
                is_prime = 0;
                break;
            }
        }
        if (is_prime == 1) {
            if (q - p == 2) {
                printf("%d, %d\n", p, q);
            }
            p = q;
        }
    }
    return 0;
}

### Zadanie 6.
Napisz program w asemblerze x86 (32-bit), który liczy silnię podwójną n!! na liczbach 128 bitowych. Liczba n pobierana jest z argumentów argc, argv (lub ze standardowego wejścia) oraz wynik wysyłany jest na standardowe wyjście.

Pokrótce zasada działania:
- liczba 128-bitowa składa się z czterech liczb 32-bitowych
- bierzemy wartość silni do policzenia
- w każdym kroku mnożymy obecnie posiadaną liczbę razy n - k, gdzie n - liczba, której silnię liczymy, k - numer iteracji
- na koniec wypisujemy liczbę, począwszy od najbardziej znaczącego bitu 

### Zadanie 10.
Napisz program w asemblerze dla procesora ARM, który oblicza największy wspólny dzielnik dwóch liczb. Pobieraj dwie liczby, ze standardowego wejścia i wysyłaj wynik na standardowe wyjście.

Program wykonuje kod, który zapisany w języku C wygląda następująco:

    while (i != j)
    {
       if (i > j)
           i -= j;
       else
           j -= i;
    }

Skrócona wersja jest opisana w dokumentacji ARM:
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.kui0100a/armasm_cegihjgh.htm
http://www.keil.com/support/man/docs/armasm/armasm_dom1359731162809.htm

Więcej ciekawych materiałów:
http://thinkingeek.com/2013/02/02/arm-assembler-raspberry-pi-chapter-9/
http://harunurhan.github.io/great-common-divisor-in-arm*/
