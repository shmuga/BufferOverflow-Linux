  #include <stdio.h>
  #include <string.h>

  void doit(char **params)
  {
          char buf[8];
          strcpy(buf, params[1]);
          printf("%s\n", buf);
  }

  int main(int argc, char **argv)
  {
          printf("So... The End...\n");
          doit(argv);
          printf("or... maybe not?\n");
          return 0;
  }