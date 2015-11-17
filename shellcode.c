char shellcode[] = "ë1À1Û1Ò1É°³Y²Í€1À°1ÛÍ€èâÿÿÿhack";
int main(int argc, char **argv)
{
  int (*func)();
  func = (int (*)()) shellcode;
  (int)(*func)();
  return 0;
}