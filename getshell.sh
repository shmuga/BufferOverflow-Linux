RES=`for i in $(objdump -d shellcode |grep "^ " |cut -f2); do echo -n '\x'$i; done; echo`
echo $RES
sed -i "s/char.*=.*\".*\"\;/char shellcode[] = \"${RES}\"\;/" shellcode.c
