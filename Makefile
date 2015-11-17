ASM = nasm
ASMFLAGS = -f elf

CC = gcc
CFLAGS = -g -z execstack -Wall -fno-stack-protector

default: clean victim shellcode getasm

# creating the victim
victim: victim.c
	$(CC) $(CFLAGS) -o victim victim.c

# generating shellcode injector
shellinject: getasm shellcode.c
	$(CC) $(CFLAGS) -o shellcode shellcode.c
# for generating real shellcode from asm
getasm: shellcode
	sh getshell.sh
shellcode: shellcode.o
	ld -o shellcode shellcode.o
shellcode.o:
	$(ASM) $(ASMFLAGS) shellcode.asm


# cleaning all the crap
clean:
	$(RM) shellcode victim *.o *~