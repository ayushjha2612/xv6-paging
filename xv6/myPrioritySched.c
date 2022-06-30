#include "types.h"
#include "user.h"

#define NUM_PROCESSES 10

int main(int argc, char *argv[])
{
  int i, pid;
  double garbage = 0,j;
  for (i = 0; i< NUM_PROCESSES ; i++)
  {
    pid = fork();
    if (pid < 0)
      printf(1, "failed\n");
    else if (pid == 0)
    {
      setPriority(i%10);
      sleep(1);
      for (j = 0; j < 10000000; j++)
        garbage = garbage + 1.2345 * 98.765* 23.456;
      printf(1, "Child pid %d and child priority : %d\n", getpid(), getPriority());
      break;
    }
  }

  for (i = 0; i < NUM_PROCESSES; i++)
    wait();

  exit();
}